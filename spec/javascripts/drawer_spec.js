describe('Drawer', function () {
	var drawer

	describe('When you first see the page', function () {
	  beforeEach(function () {
	    drawer = new Drawer();
	  });

	  it('then the drawer is hidden', function() {
      expect(drawer.isOpen).not.toBeTruthy();
    });
	});

	describe('When show is triggered', function () {
	  beforeEach(function () {
	    drawer = new Drawer();
	    drawer.show()
	  });

	  it('then the drawer is open', function() {
      expect(drawer.isOpen).toBeTruthy();
    });
	});

	describe('When show is triggered twice', function () {
	  beforeEach(function () {
	    drawer = new Drawer();
	    drawer.show();
	    drawer.show();
	  });

	  it('then the drawer is open', function() {
      expect(drawer.isOpen).toBeTruthy();
    });
	});

	describe('When hide is triggered twice', function () {
	  beforeEach(function () {
	    drawer = new Drawer();
	    drawer.hide();
	    drawer.hide();
	  });

	  it('then the drawer is closed', function() {
      expect(drawer.isOpen).not.toBeTruthy();
    });
	});

	describe('When the drawer is toggled', function () {
	  beforeEach(function () {
	    drawer = new Drawer();
	    drawer.toggle();
	  })

	  it('then it opens', function() {
      expect(drawer.isOpen).toBeTruthy();
    })
	});

	describe('When the drawer is opened, then closed', function () {
	  beforeEach(function () {
	    drawer = new Drawer();
	    drawer.show();
	    drawer.hide();
	  })

	  it('then it is closed', function() {
      expect(drawer.isOpen).not.toBeTruthy()
    });
	});

	describe('When the drawer is toggled twice', function () {
	  beforeEach(function () {
	    drawer = new Drawer();
	    drawer.toggle();
	    drawer.toggle();
	  })

	  it('then it is closed', function() {
      expect(drawer.isOpen).not.toBeTruthy();
    });
	});

	describe('When the drawer is toggled three times', function () {
	  beforeEach(function () {
	    drawer = new Drawer();
	    drawer.toggle();
	    drawer.toggle();
	    drawer.toggle();
	  })

	  it('then it is open', function() {
      expect(drawer.isOpen).toBeTruthy();
    })
	});
});
