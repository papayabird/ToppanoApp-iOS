
//整個code複製,貼到instruments的script上面執行即可

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

//Main
target.logElementTree();
target.delay(5);
loginFB();
scrollingWithTap();
target.delay(1);
selectTableView()
backToRootView();


function loginFB()
{
    target.frontMostApp().mainWindow().buttons()["FB"].tap();
    UIALogger.logMessage("login success!");
    target.delay(3);
    target.tap({x:720, y:720});
}

function scrollingWithTap()
{
    target.delay(1);
    target.frontMostApp().mainWindow().collectionViews()[0].scrollRight();
    target.delay(1);
    target.frontMostApp().mainWindow().collectionViews()[0].scrollRight();
    target.delay(1);
    target.frontMostApp().mainWindow().collectionViews()[0].scrollLeft();
    target.delay(1);
    target.frontMostApp().mainWindow().collectionViews()[0].scrollLeft();
    target.delay(1);
    target.frontMostApp().mainWindow().collectionViews()[0].cells()[0].tap();
}

function selectTableView() 
{
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].tap();
    target.delay(2);
    target.frontMostApp().mainWindow().tableViews()[0].cells()[2].tap();
    target.delay(2);
    target.frontMostApp().mainWindow().tableViews()[0].cells()[3].tap();
    target.delay(2);
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].tap();
    target.delay(2);
    target.frontMostApp().mainWindow().tableViews()[0].cells()[5].tap();
    target.delay(2);
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].tap();
    target.delay(2);
}

function backToRootView ()
{
    target.frontMostApp().mainWindow().buttons()["Back"].tap();
    target.delay(1);
    target.frontMostApp().mainWindow().buttons()["Logout"].tap();
}

