describe('PreviousWinners', function () {
  var winners,
    mock,
    auctions,
    settings,
    matcher,
    metrics,
    charts

  beforeEach(function(){
    mock = auctionsMock

    auctions = _.sortBy(mock.auctions, 'id')

    winners = {}
    winners.metrics = new Metrics(auctions)
    winners.charts = new Charts(auctions)

    metrics = winners.metrics
    charts = winners.charts
  })

  describe('mock data', function () {

    it('is the correct data', function() {
      expect(mock.auctions).not.toBe(undefined)
      expect(mock.auctions).toEqual(jasmine.any(Object))
      expect(mock.auctions.length).toEqual(4)
      expect(mock.auctions[0].issue_url).toBe('https://github.com/18F/tock/issues/328')
    })
  })

  describe('winners page object', function() {

    it("called winners, and it exists", function(){
      expect(winners).not.toBe(undefined)
      expect(winners).toEqual(jasmine.any(Object))
    })
  })

  describe('Charts object', function() {

    it("exists", function(){
      expect(charts).not.toBe(undefined)
      expect(charts).toEqual(jasmine.any(Object))
    })

    it("has an attribute, textRotation", function(){
      expect(charts.textRotation).not.toBe(undefined)
      expect(charts.textRotation).toEqual(jasmine.any(Number))
    })


    it("has several methods", function(){
      expect(charts.create).toEqual(jasmine.any(Object))
      expect(charts.load).toEqual(jasmine.any(Object))
      expect(charts.generate).toEqual(jasmine.any(Function))
      expect(charts.linear).toEqual(jasmine.any(Function))
      expect(charts.scale).toEqual(jasmine.any(Function))
      expect(charts.settings).toEqual(jasmine.any(Function))
      expect(charts.foo).not.toEqual(jasmine.any(Object))
    })
  })

  describe('Metrics object', function() {

    it("exists", function(){
      expect(metrics).not.toBe(undefined)
      expect(metrics).toEqual(jasmine.any(Object))
    })

    it("has the correct number of auctions", function(){
      expect(metrics.auctions).not.toBe(undefined)
      expect(metrics.auctions).toEqual(jasmine.any(Array))
      expect(metrics.auctions.length).toBe(4)
    })


    it("has the correct auction duration", function(){
      expect(metrics.auctionLength).not.toBe(undefined)
      expect(metrics.auctionLength).toEqual(7.25)
    })

    it("has the correct average winning bid", function(){
      expect(metrics.avgWinningBids).not.toBe(undefined)
      expect(metrics.avgWinningBids).toEqual(2112.5)
    })

    it("has the correct number of bids per auction", function(){
      expect(metrics.bidsPerAuction).not.toBe(undefined)
      expect(metrics.bidsPerAuction).toEqual(3.25)
    })

    it("has the correct number of repos", function(){
      expect(metrics.repos).not.toBe(undefined)
      expect(metrics.repos).toEqual(4)
    })

    it("has the correct number of unique winners", function(){
      expect(metrics.uniqueWinners).not.toBe(undefined)
      expect(metrics.uniqueWinners).toEqual(3)
    })

    it("has the correct number of bidding vendors", function(){
      expect(metrics.biddingVendors).not.toBe(undefined)
      expect(metrics.biddingVendors).toEqual(8)
    })

    it("has javascript selectors", function(){
      expect(metrics.selectors).not.toBe(undefined)
      expect(metrics.selectors).toEqual(jasmine.any(Object))
    })
  })

  describe('donut 1 (Projects) data', function () {
    beforeEach(function(){
      settings = charts.settings.donut1
      matcher = {
        "cols":[
          ["18f/openopps-platform",1],
          ["18f/fedramp-micropurchase",1],
          ["18f/micropurchase",1],
          ["18f/tock",1]
        ]
      }
    })

    it('is returning an object', function(){
      expect(settings).toEqual(jasmine.any(Object))
      expect(settings.cols).toEqual(jasmine.any(Object))
      expect(settings.cols).toEqual(jasmine.any(Array))
    })

    it('the array has the correct objects', function(){
      expect(settings).toEqual(matcher)
    })
  })

  describe('donut 2 (Languages) data', function () {
    beforeEach(function(){
      settings = charts.settings.donut2
      matcher = {
        "cols":[
          ["google sheets",1],
          ["ruby",2],
          ["python",2],
          ["yml",1],
          [],
          ["go",1]
        ]
      }
    })

    it('is returning an object', function(){
      expect(settings).toEqual(jasmine.any(Object))
      expect(settings.cols).toEqual(jasmine.any(Object))
      expect(settings.cols).toEqual(jasmine.any(Array))
    })

    it('has an array with the correct objects', function(){
      expect(settings).toEqual(matcher)
    })
  })

  describe('chart 2 (Average winning bid) data', function () {
    beforeEach(function(){
      settings = charts.settings.chart2
      matcher = {
        "cols":[
          [
            "bids_dates",
            "2016-3-4",
            "2016-3-14",
            "2016-3-14",
            "2016-3-17"
          ],
          ["bids",3000,250,3200,2000],
          [
            "means_dates",
            "2016-3-4",
            "2016-3-14",
            "2016-3-17"
          ],
          ["means",3000,1725,2000]
        ]
      }
    })

    it('is returning an object with the correct attributes', function(){
      expect(settings).toEqual(matcher)
    })

    it('has the correct number of columns', function(){
      expect(settings.cols.length).toEqual(4)
    })
  })

  describe('chart 4 (Histogram timeseries) data', function () {
    beforeEach(function(){
      settings = charts.settings.chart4
      matcher = {
        "cols":[
          ["date_community","2016-3-4","2016-3-14","2016-3-17"],
          ["Bidders",4,6,2],
          ["Open-source projects",1,2,1],
          ["Auctions",1,2,1]],
        "x":"date_community"
      }
    })

    it('is returning an object with the correct attributes', function(){
      expect(settings).toEqual(matcher)
    })

    it('has the correct number of columns', function(){
      expect(settings.cols.length).toEqual(4)
    })

    it('has the correct x attribute', function(){
      expect(settings.x).toEqual(matcher.x)
    })
  })

  describe('chart 5 (Bubble chart) data', function () {
    beforeEach(function(){
      settings = charts.settings.chart5
      matcher = {
        "cols":[
          ["date_0","2016-3-4"],
          ["18",5],
          ["date_1","2016-3-14"],
          ["21",5],
          ["22",1],
          ["date_2","2016-3-17"],
          ["23",2]
        ],
        "z":{
          "18": 3000,
          "21": 250,
          "22": 3200,
          "23": 2000
        },
        "xs":{
          "18":"date_0",
          "21":"date_1",
          "22":"date_1",
          "23":"date_2"
        }
      }
    })

    it('is returning an object with the correct attributes', function(){
      expect(settings).toEqual(matcher)
    })

    it('has the correct winning bids', function(){
      expect(settings.z).toEqual(matcher.z)
    })

    it('has the correct dates', function(){
      expect(settings.xs).toEqual(matcher.xs)
    })
  })
})
