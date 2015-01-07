class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
    # args = NSProcessInfo.processInfo.arguments # get the arguments passing to your console-like app
    # str = args[1] || "hello world"
    # p str
    alert = NSAlert.new
    alert.messageText = 'Hello World!'
    alert.runModal
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.title = 'Care Plan Dashboard'
    @status_menu = NSMenu.new
    @status_menu.addItem createMenuItem("Greetings", 'greetings')
    # Build the scroll view that will embed our outline view.
    scrollView = NSScrollView.alloc.initWithFrame(@mainWindow.contentView.bounds)
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable
    scrollView.hasVerticalScroller = true
    @mainWindow.contentView.addSubview(scrollView)

    # Build the outline view.
    outlineView = NSOutlineView.alloc.initWithFrame(scrollView.bounds)
    outlineView.dataSource = outlineView.delegate = self
    outlineView.addTableColumn(NSTableColumn.alloc.initWithIdentifier('Path').tap { |col|
      col.minWidth = 360
    })
    outlineView.outlineTableColumn = outlineView.tableColumns[0]
    outlineView.headerView = nil # hide columns headers

    # Add the outline view into the scroll view.
    scrollView.documentView = outlineView

    @mainWindow.orderFrontRegardless
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

end
