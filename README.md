# SwiftUIDesign

同一個待辦清單卡片 App,用**三種狀態管理架構各實作一次**,全部收進**同一個 App**,以 `TabView` 分頁並列對照學習:

| 分頁 | 架構 | 通知機制 | 最低版本 |
|------|------|----------|----------|
| **BaseClass** | 每層一個 ViewModel 的傳統 MVVM(base class + override) | `ObservableObject`(object 級) | iOS 15.1 |
| **Equatable** | 單一 ViewModel + UiState 快照 + 單向資料流,含 `Equatable` 重繪優化 | `ObservableObject`(object 級) | iOS 15.1 |
| **Observable** | 同上,但 ViewModel 改用 iOS 17 的 `@Observable` 屬性級追蹤 | `@Observable`(屬性級) | iOS 17.0 |

三者**共用同一套資料層**(封裝成 `CoreKit` SPM package),差別只在「畫面狀態怎麼持有、怎麼通知更新」。

## 功能

- 從 DataSource 載入多張任務卡片並以卡片列表呈現
- 每個任務項目可勾選/取消完成(劃線、打勾)
- 每個任務項目可標記/取消旗標(flag)
- 卡片項目超過上限時可展開／收合(「看更多」),上限由資料的 `collapsedItemLimit` 決定
- 內建 stub JSON 假資料(`useStub: true`),免後端即可執行

## 需求

- iOS 15.1+(Observable 分頁需 iOS 17.0+)
- Xcode 16+
- Swift 5.9(CoreKit package)

## 開始使用

用 Xcode 開啟 `20260627_SwiftUIDesign.xcodeproj` 後直接 Run,App 會以 `TabView` 同時提供 BaseClass / Observable / Equatable 三個分頁。預設 `NetworkClient(useStub: true)` 讀取本地 `sampleJSON.json`,不需要任何後端設定。

## 共用的資料層 — `CoreKit` package

資料層抽成獨立的 local SPM package `Packages/CoreKit`,拆成三個可獨立編譯的 target:

```
Networking ─────────────┐
                        ▼
TaskCardsDomain ──▶ TaskCardsData
```

| Target | 角色 |
|--------|------|
| **Networking** | 泛型化請求層(`NetworkClient` / `TargetType`),iOS 15 原生 `async/await` |
| **TaskCardsDomain** | 領域模型 `ParsedCard` 與 `TaskCardsDataSourceProtocol`,不依賴其他 target |
| **TaskCardsData** | `GetTaskCardsTarget` / DTO / `TaskCardsParser` / `TaskCardsDataSource`,實作 domain 的 protocol |

資料流:

```
GetTaskCardsTarget ──(stub / network)──▶ NetworkClient
        │                                    │ decode
        ▼                                    ▼
GetTaskCardsResponseModel ──TaskCardsParser──▶ ParsedCard
        │                                    │
   TaskCardsDataSource ◀─────────────────────┘
        │ async/await
        ▼
   ( ViewModel 層 — 見下方三種架構 )
```

設計重點:
- **DTO 與領域模型分離**:`GetTaskCardsResponseModel`(DTO,欄位皆 optional,在 `TaskCardsData`)由 `TaskCardsParser` 補預設值轉成非空的 `ParsedCard`(領域模型,在 `TaskCardsDomain`),nil 處理集中一處。
- **依賴反轉**:`TaskCardsDataSourceProtocol` 定義在 `TaskCardsDomain`,App 只依賴 protocol,測試可換假 DataSource;開發用 `useStub` 走本地 JSON。
- **模組邊界即依賴規則**:`TaskCardsDomain` 不依賴任何人,`TaskCardsData` 依賴 domain + networking,用 target 邊界把「誰能依賴誰」變成編譯期約束。

---

## 架構 A — BaseClass:每層一個 ViewModel(MVVM)

每張卡片、每個項目各自有一個 `ObservableObject`;`ParentView` 持有 `[ChildCardViewModelBase]`,每個 child VM 再持有 `[ItemViewModelBase]`。每層再拆成 **base class(共用狀態 + 可 override 的空方法)+ 子類別(實作)**。

```
ParentViewModel ──▶ ChildCardViewModel ──▶ ItemViewModel
(: ParentViewModelBase) (: ChildCardViewModelBase) (: ItemViewModelBase)
        │                    │                    │
        ▼                    ▼                    ▼
   ParentView           ChildCardView         ItemView
```

設計重點:
- **狀態顆粒度細**:每張卡 / 每個項目一個 `ObservableObject`。改一個項目只有那顆 `ItemViewModel` 發 `objectWillChange`,只有對應的 `ItemView` 重算 body,上層完全不被驚動。
- **靠拆 object 達成細顆粒**:`ObservableObject` 的通知是 object 級(任一 `@Published` 變動就通知所有觀察者),這裡靠「把狀態切成很多小 object」讓每次通知的影響範圍最小。
- **base / subclass 分層**:`*ViewModelBase` 放共用狀態(如 `isExpanded` 初始化)與空的 action 方法,子類別 override 實作;View 依賴 base 型別,便於替換與收斂共用邏輯。

---

## 架構 B — Equatable:單一 ViewModel + UiState

整個畫面狀態收斂成一顆 `UiState` 快照;row 是無狀態純元件(data 往下、event 往上),只有最上層 `ParentView` 依賴 ViewModel。

### 畫面狀態流(State down / Event up)

```
EquatableParentViewModel ── @Published UiState(cards, isLoading) ──┐  state ↓
        ▲                                                          ▼
        │ actions (toggleItem / toggleItemFlag / toggleExpanded)  EquatableParentView   ← 唯一依賴 ViewModel 的層
        │                                                          │ card + callbacks ↓
        └──────────────── callbacks ◀───────────────── EquatableChildCardView (stateless)
                                                           │ item + callbacks ↓
                                                     EquatableItemView (stateless)
```

| 層 | 角色 |
|----|------|
| **ViewModel** (`EquatableParentViewModel`) | 唯一的 screen ViewModel,持有單一 `UiState` 與 user actions |
| **State** (`EquatableCardState` / `EquatableItemState`) | 畫面狀態的值型別快照,conform `Equatable` |
| **View — screen** (`EquatableParentView`) | 讀 `uiState`、把 actions 包成 callback 往下傳 |
| **View — rows** (`EquatableChildCardView` / `EquatableItemView`) | 無狀態純元件:只吃 data + callback,不認識 ViewModel,可單獨 Preview |

設計重點:
- **單一 UiState 快照**:`cards`、`isLoading` 一起更新、一起被觀察,避免散落旗標湊出不一致狀態(對應 Compose 的 UiState)。
- **無狀態 row + callback hoisting**:事件由下往上冒(`ItemView` 發 → `ChildCardView` 補 `item.id` → `ParentView` 補 `card.id` → 呼叫 ViewModel)。因為 row 拿到的是唯讀 value copy,**一定要**把事件往上傳回 ViewModel 才能改狀態。只有 `ParentView` 綁 ViewModel。
- **狀態上提以撐過捲動**:`isExpanded` 放在 `UiState`(而非 row 的 `@State`),因為 `LazyVStack` 會銷毀畫面外的 row,狀態在頂層才能捲回來後保留。
- **`Equatable` 重繪優化**:`uiState` 是 struct,改任一欄位都會驚動 `ParentView` 重算 → `ForEach` 重新評估**所有可視 row**。讓 state 與 row view conform `Equatable` 並套 `.equatable()`,SwiftUI 即可跳過「資料沒變」的 row,把整批重算縮回到「只有真正變動的那張卡 / 那個項目」。

---

## 架構 C — Observable:@Observable

結構同架構 B,但 `ObservableParentViewModel` 改用 iOS 17 的 `@Observable` macro 取代 `ObservableObject` + `@Published`,`ParentView` 的 `@StateObject` 改為 `@State`。

設計重點:
- **屬性級追蹤**:`@Observable` 只通知「body 實際讀取了該屬性」的 view,取代 `ObservableObject` 的 object 級通知。
- **限制**:本專案的 `uiState` 是一整顆 struct、`ParentView` 讀的是 `uiState.cards` 整個陣列,因此改任一張卡仍會驚動 `ParentView`;單靠 `@Observable` 收益有限,要更細仍需配合 `Equatable` 或把狀態切細。
- **代價**:`@Observable` 需 iOS 17.0,此分頁因此要求 iOS 17。

---

## 三種架構比較

| 面向 | A. BaseClass | B. Equatable | C. Observable |
|------|------|------|------|
| 畫面狀態 | 分散在各層 VM | 一顆 `UiState` 快照 | 一顆 `UiState` 快照 |
| Row | 各自持有 VM | 無狀態,data in / event out | 無狀態,data in / event out |
| 依賴 ViewModel | 每層 View 各綁一個 | 只有 `ParentView` | 只有 `ParentView` |
| 通知機制 | `ObservableObject`(object 級,靠拆小 object 取得細顆粒) | `ObservableObject`(object 級) | `@Observable`(屬性級) |
| 改一個項目的 body 重算 | 只有該 `ItemView` | 整個可視區(加 `Equatable` 後縮到該卡/項目) | 仍驚動 `ParentView`,需配 `Equatable` |
| 對齊 Android Compose | 偏 iOS 傳統 MVVM | ✅ 高(UiState / state hoisting) | ✅ 高 |
| 最低版本 | iOS 15.1 | iOS 15.1 | iOS 17.0 |
| 適合 | 各區塊狀態獨立、想要細顆粒重繪 | 畫面狀態需整體一致、row 想重用/好測試 | 同 B,且專案已能鎖定 iOS 17 |

> 註:以上「body 重算」指 SwiftUI 重新計算 view 描述的範圍,不等於實際螢幕重繪(SwiftUI diff 後只重繪真正變動的部分)。差異主要是 CPU 重算次數。

## 目錄結構

```
20260627_SwiftUIDesign/
├── _0260627_SwiftUIDesignApp.swift   App 入口,TabView 並列三種架構
└── Architectures/
    ├── BaseClass/                     架構 A — 每層一個 ViewModel(base + subclass)
    │   ├── Components/                ExpandToggleButton
    │   └── Feature/{01_Parent, 02_Child, 03_Item}/
    ├── Equatable/                     架構 B — 單一 ViewModel + UiState + Equatable
    │   ├── Components/                EquatableExpandToggleButton
    │   └── Feature/{01_Parent, 02_Child, 03_Item}/
    └── Observable/                    架構 C — 單一 ViewModel + UiState + @Observable
        ├── Components/                ObservableExpandToggleButton
        └── Feature/{01_Parent, 02_Child, 03_Item}/

Packages/CoreKit/                      共用資料層 SPM package
└── Sources/
    ├── Networking/                    NetworkClient / TargetType
    ├── TaskCardsDomain/               ParsedCard / TaskCardsDataSourceProtocol
    └── TaskCardsData/                 Target / DTO / TaskCardsParser / TaskCardsDataSource / sampleJSON.json
```
