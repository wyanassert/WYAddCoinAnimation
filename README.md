# WYAddCoinAnimation

#### Produce some coins and then gather coins into a point
----
## how to use:
1. drag the directory `AddCoinView` into your project.
2. add header
  ```
    #import "AddCoinAnimationManager.h"
  ```
3. use these code
  ```
  @property (nonatomic, strong) AddCoinAnimationManager *addCoinAnimationManager;

    - (AddCoinAnimationManager *)addCoinAnimationManager {
        if(!_addCoinAnimationManager) {
            _addCoinAnimationManager = [[AddCoinAnimationManager alloc] init];
            _addCoinAnimationManager.snapRect = CGRectMake(300, 0, 20, 20);
            _addCoinAnimationManager.displayRect = CGRectMake(0, 0, 300, 300);
            _addCoinAnimationManager.maxDisplayAmount = 20;
            _addCoinAnimationManager.delegate = self;
            _addCoinAnimationManager.associatedView = self.view;
        }
        return _addCoinAnimationManager;
    }
  ```

4. produce coins:
  ```
    [self.addCoinAnimationManager addCoins:10;
  ```
5. gather coins to a point and dismiss
  ```
    [self.addCoinAnimationManager popCoins:10];
  ```
6. Or, you just want to remove them
  ```
    [self.addCoinAnimationManager removeCoins:10];
  ```
7. hide or show all the coins
  ```
    [self.addCoinAnimationManager setCoinsHide:YES];
  ```
8. Force to stop and remove all the coins
  ```
    [self.addCoinAnimationManager stop];
  ```

PS. Just download project and run the demo within.
