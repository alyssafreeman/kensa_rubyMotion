class RssReaderController
  def initialize
    @text_source = NSTextField.alloc.initWithFrame(NSMakeRect(11, 110, 390, 25))
    @text_source.stringValue = 'source_folder'
    @text_source.bezelStyle = NSRoundedBezelStyle
    @text_source.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    app.window.contentView.addSubview(@text_source)

    @text_destination = NSTextField.alloc.initWithFrame(NSMakeRect(11, 80, 390, 25))
    @text_destination.stringValue = 'destination_file.xls'
    @text_destination.bezelStyle = NSRoundedBezelStyle
    @text_destination.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    app.window.contentView.addSubview(@text_destination)

    button = NSButton.alloc.initWithFrame(NSMakeRect(415, 80, 61, 55))
    button.setButtonType NSToggleButton
    button.title = 'Start'
    button.alternateTitle = 'Stop'
    button.setState NSOffState
    button.action = 'toggleProgress:'
    button.target = self
    button.bezelStyle = NSRoundedBezelStyle
    button.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin
    app.window.contentView.addSubview(button)

    @indicator = NSProgressIndicator.alloc.initWithFrame(NSMakeRect(15, 40, 450, 10))
    @indicator.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    @indicator.setDisplayedWhenStopped(FALSE)
    app.window.contentView.addSubview(@indicator)

    @progress = NSTextView.alloc.initWithFrame(NSMakeRect(205, 15, 80, 20))
    @progress.drawsBackground = false
    @progress.selectable = false
    @progress.setString 'Not Started'
    app.window.contentView.addSubview(@progress)
  end

  def app
    NSApp.delegate
  end

  # def loadRSS(url)
  #   @data = []
  #   parser = RSSParser.alloc.initWithDelegate(self, URL:url)
  #   parser.parse
  # end

  # def retrieveRSSFeed(sender)
  #   loadRSS(@text_url.stringValue)
  # end

  def processXML
    # probably something like this....
    @data = []
    parser = XMLProcessor.alloc.initWithDelegate(self, SOURCE:@text_source.stringValue, DEST:@text_destination.stringValue)
    parser.parse
  end

  def validate_input_validity
    return false if @text_source.stringValue.nil?
    return false if @text_destination.stringValue.nil?
    true
  end

  def toggleProgress(sender)
    if sender.state == NSOffState
      @timer.invalidate
      @progress.setString 'Stopped'
      @indicator.stopAnimation(self)
    else
      @duration = 0
      @progress.setString 'Starting...'
      puts "Source Folder: #{@text_source.stringValue}"
      puts "Destination File: #{@text_destination.stringValue}"
      @indicator.startAnimation(self)
      # if validate_input_validity
      #   processXML
      # end
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                                                      :target   => self,
                                                      :selector => 'timerFired',
                                                      :userInfo => nil,
                                                      :repeats  => true)
    end
  end

  def timerFired
    @progress.setString "   #{@duration}%"
    @duration+=2
    if @duration == 100
      @timer.invalidate
      @progress.setString 'Completed!'
      @indicator.stopAnimation(self)
      toggleProgress(self)
    end
  end
end