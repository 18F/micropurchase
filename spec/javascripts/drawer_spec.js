describe('Drawer', function () {
  var drawer

  describe('When you first go to the homepage, the drawer', function () {
    beforeEach(function () {
      drawer = new Drawer();
    });

    it('is hidden', function() {
      expect(drawer.isOpen).not.toBeTruthy();
    });
  });

  describe('When show is triggered, the drawer', function () {
    beforeEach(function () {
      drawer = new Drawer();
      drawer.show()
    });

    it('is open', function() {
      expect(drawer.isOpen).toBeTruthy();
    });
  });

  describe('When show is triggered twice, the drawer', function () {
    beforeEach(function () {
      drawer = new Drawer();
      drawer.show();
      drawer.show();
    });

    it('is open', function() {
      expect(drawer.isOpen).toBeTruthy();
    });
  });

  describe('When hide is triggered twice, the drawer', function () {
    beforeEach(function () {
      drawer = new Drawer();
      drawer.hide();
      drawer.hide();
    });

    it('is closed', function() {
      expect(drawer.isOpen).not.toBeTruthy();
    });
  });

  describe('When the drawer is toggled, the drawer', function () {
    beforeEach(function () {
      drawer = new Drawer();
      drawer.toggle();
    })

    it('is open', function() {
      expect(drawer.isOpen).toBeTruthy();
    })
  });

  describe('When the drawer is opened, then closed, the drawer', function () {
    beforeEach(function () {
      drawer = new Drawer();
      drawer.show();
      drawer.hide();
    })

    it('is closed', function() {
      expect(drawer.isOpen).not.toBeTruthy()
    });
  });

  describe('When the drawer is toggled twice, the drawer', function () {
    beforeEach(function () {
      drawer = new Drawer();
      drawer.toggle();
      drawer.toggle();
    })

    it('is closed', function() {
      expect(drawer.isOpen).not.toBeTruthy();
    });
  });

  describe('When the drawer is toggled three times, the drawer', function () {
    beforeEach(function () {
      drawer = new Drawer();
      drawer.toggle();
      drawer.toggle();
      drawer.toggle();
    })

    it('is open', function() {
      expect(drawer.isOpen).toBeTruthy();
    })
  });
});
