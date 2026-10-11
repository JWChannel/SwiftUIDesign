# SwiftUIDesign

同一個待辦清單卡片 App,用同一套 MVVM 分層**實作兩次**,在同一個 App 裡以 `TabView` 並列。兩套的分層、命名、資料流相同,差別只在觀察機制:

| 分頁 | 觀察機制 | 適用的部署目標 |
|------|----------|----------------|
| **ObservableObject** | `ObservableObject` + `@Published` | iOS 15、16 |
| **Observable** | `@Observable` | iOS 17+ |

## 功能

- 載入多張任務卡片並以列表呈現
- 任務項目可勾選完成、標記旗標
- 卡片項目超過上限時可展開／收合
- 內建 stub JSON 假資料,不需要後端

## 需求

- iOS 17.0、Xcode 26+
- CoreKit package:Swift 5.9、iOS 15+

## 開始使用

用 Xcode 開啟 `20260627_SwiftUIDesign.xcodeproj`,專案有兩個 scheme:

| Scheme | 用途 |
|--------|------|
| `20260627_SwiftUIDesign` | 主 App,讀取本地 `sampleJSON.json` |
| `20260627_SwiftUIDesignPreviews` | Preview 畫布與單元測試(`⌘U`),只用假資料 |

## 架構

```
HomeView          建立並持有 ParentViewModel,決定用哪個 DataSource
   ▼
ParentView<VM>    整頁:載入中或卡片列表
   ▼
ChildView<VM>     一張卡片
   ▼
ItemView<VM>      一個任務項目
```

- View 以泛型收 ViewModel 協定,只讀不改狀態。
- 每一層各有自己的 ViewModel,勾選一個項目只重繪那個項目。
- 動作以 `ChildAction` 經 closure 往上傳,統一由 `ParentViewModel.handle(_:)` 處理。
- Preview 與測試用真的 ViewModel 配假 DataSource。

### 資料層 — `CoreKit` package

```
Networking ─────────────┐
                        ▼
TaskCardsDomain ──▶ TaskCardsData(RequestModel, ResponseModel)
```

`TaskCardsData` 用 `Networking` 發請求,並實作 `TaskCardsDomain` 定義的協定。`Networking` 與 `TaskCardsDomain` 互不相依。

| Target | 角色 |
|--------|------|
| **Networking** | 泛型化請求層 |
| **TaskCardsDomain** | 領域模型與 DataSource 協定,不依賴其他 target |
| **TaskCardsData** | DTO、Parser 與 DataSource 實作 |

### Preview target

`20260627_SwiftUIDesignPreviews` 和主 App 共用同一個原始碼資料夾,但排除 App 入口與兩個 `HomeView`,只連結 `TaskCardsDomain`,不會編譯到網路層與資料層。

- `#Preview` 與假資料以 `#if Previews` 包住,只存在於這個 target。
- 新增的檔案會自動進兩個 target;如果它 import 了資料層,要在 Target Membership 把它從 Preview target 取消勾選。

## 目錄結構

```
20260627_SwiftUIDesign/                 主 App 與共用的畫面層
└── Architectures/
    ├── Shared/                         兩套共用的元件與假資料
    ├── IOS15/                          ObservableObject 的寫法
    │   ├── Home/
    │   ├── Parent/
    │   ├── Child/
    │   └── Item/
    └── IOS17/                          @Observable 的寫法,檔案與上面一一對應

20260627_SwiftUIDesignPreviews/         Preview target 的入口
20260627_SwiftUIDesignTests/            單元測試(Swift Testing)
Packages/CoreKit/                       資料層 SPM package
```
