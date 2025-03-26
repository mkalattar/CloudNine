# Store App Task

## Getting Started
The project doesn't use Coacapods and only uses SPM, so installation should be straightforward. The target iOS version used for this project is iOS 15.3

## Included Features:
- Pagination
- Caching using CoreData and image caching using NSCache.
- Layout Style Switching (Grid&List) using Compositional Layout in UICollectionView.
- Monitoring Network Connectivity using NWPathMonitor and display an error message based on Connectivity.
- Error Handling and customized error localizedDescriptions.
- SkeletonView for loading and handled for both Grid and List views.
- Handled for small devices such as iPhone SE.
- DI using Inits without third party libraries like Factory.
- UI was done programmatically.
- View item details after it's selected.
- Async/Await in Network Requests
- Combine in UI handling

## Architecture used and Design Pattern
The project follows  **MVVM (Model-View-ViewModel)**  for separation of concerns and scalability alongside Repository Pattern for multiple sources for the Data.

**Repository Pattern**:
- Enables fetching data from either  **network requests**  or  **CoreData**  (offline mode).
- If a network request fails, the app retrieves cached data instead.

**Communication Approach:**

-  **View / ViewModel**: Uses  Combine  for UI updates like error alerts and collection view updates.
- **ViewController / ViewModel**: The ViewModel is accessed via a protocol for better testability.
- **ViewModel / Repository**: Handles network requests, error handling, and CoreData retrieval.

**Network Layer:**
- Implements  **Builder Pattern**  for constructing API requests (baseURL,  path,  queryParams,  HTTPMethod, etc.).
- Returns data via  Async/Await  for better asynchronous handling.
- Custom error messages (poorOrNoConnection,  badRequest, etc.) for better user experience.

