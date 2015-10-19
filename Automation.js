
//整個code複製,貼到instruments的script上面執行即可

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

//Main
target.logElementTree();
target.delay(5);
loginFB();
scrollingWithTap();

function loginFB()
{
    target.frontMostApp().mainWindow().buttons()["FB"].tap();
    UIALogger.logMessage("login success!");
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


target.delay(1);
target.frontMostApp().mainWindow().buttons()["Back"].tap();
target.delay(1);
target.frontMostApp().mainWindow().buttons()["Logout"].tap();
