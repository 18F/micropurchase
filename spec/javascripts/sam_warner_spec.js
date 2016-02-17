describe('SamWarner', function () {
  var warner, $fixture

  beforeEach(function () {
    $fixture = $('<div class="auction-alert"><a class="warning-hide-trigger">hide trigger</a></div> <a class="warning-show-trigger" style="display: none">show trigger</a>')
    $('body').prepend($fixture)
  })

  afterEach(function () {
    $fixture.remove()
  })

  describe('when the Cookie is set to hide the alert', function () {
    beforeEach(function () {
      Cookies.set('hideWarning', true)
      warner = new SamWarner()
      warner.setup()
    })

    it('hides the warning and shows the trigger', function() {
      expect($('.auction-alert').is(':visible')).not.toBeTruthy()
      expect($('.warning-show-trigger').is(':visible')).toBeTruthy()
    })

    it('listens for clicks to show the warning', function() {
      $('.warning-show-trigger').trigger('click')
      expect($('.auction-alert').is(':visible')).toBeTruthy()
      expect($('.warning-show-trigger').is(':visible')).not.toBeTruthy()
    })

    it('toggles visibility of elements back and forth', function() {
      $('.warning-show-trigger').trigger('click')
      $('.warning-hide-trigger').trigger('click')
      expect($('.auction-alert').is(':visible')).not.toBeTruthy()
      expect($('.warning-show-trigger').is(':visible')).toBeTruthy()
    })

    it('toggles cookie values', function() {
      expect(Cookies.get('hideWarning')).toEqual('true')
      $('.warning-show-trigger').trigger('click')
      expect(Cookies.get('hideWarning')).toEqual(undefined)
      $('.warning-hide-trigger').trigger('click')
      expect(Cookies.get('hideWarning')).toEqual('true')
    })
  })

  describe('when the Cookie is not set', function () {
    beforeEach(function () {
      Cookies.remove('hideWarning')
      warner = new SamWarner()
      warner.setup()
    })

    it('leaves the alert visible', function() {
      expect($('.auction-alert').is(':visible')).toBeTruthy()
      expect($('.warning-show-trigger').is(':visible')).not.toBeTruthy()
    })

    it('listens for clicks to hide the warning', function() {
      $('.warning-hide-trigger').trigger('click')
      expect($('.auction-alert').is(':visible')).not.toBeTruthy()
      expect($('.warning-show-trigger').is(':visible')).toBeTruthy()
    })

    it('toggles visibility of elements back and forth', function() {
      $('.warning-hide-trigger').trigger('click')
      $('.warning-show-trigger').trigger('click')
      expect($('.auction-alert').is(':visible')).toBeTruthy()
      expect($('.warning-show-trigger').is(':visible')).not.toBeTruthy()
    })

    it('toggles cookie values', function() {
      expect(Cookies.get('hideWarning')).toEqual(undefined)
      $('.warning-hide-trigger').trigger('click')
      expect(Cookies.get('hideWarning')).toEqual('true')
      $('.warning-show-trigger').trigger('click')
      expect(Cookies.get('hideWarning')).toEqual(undefined)
    })
  })
})
