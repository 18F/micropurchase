describe('PreviousWinners', function () {
  var winners,
	  selectors,
	  mock,
	  auctions,
	  settings,
	  matcher

  beforeEach(function(){
		winners = microp.winners
 		mock = auctionsMock;

 		auctions = _.sortBy(mock.auctions, 'id');
	})


  describe('there is a winnersPage object', function() {
  	beforeEach(function() {
      winners = window.microp.winners
      winners.onReady();
    });

  	it("it is called microp, and it exits", function(){

      expect(winners).not.toBe(undefined);
      expect(winners).toEqual(jasmine.any(Object));
    });

    it("it has a method, selectors", function(){

      expect(winners.selectors).not.toBe(undefined);
      expect(winners.selectors).toEqual(jasmine.any(Object));
    });

  })


  describe('there are metrics on top', function() {
  	beforeEach(function() {
      winners = window.microp.winners
      winners.onReady();
    });
  })

  describe('receive mock data', function () {

  	it('establish the object is correct', function() {
  		expect(mock.auctions).not.toBe(undefined)
  		expect(mock.auctions).toEqual(jasmine.any(Object));
  		expect(mock.auctions.length).toEqual(4)
  		expect(mock.auctions[0].issue_url).toBe('https://github.com/18F/tock/issues/328')
  	})

  	it('creates chart data', function() {
  		expect(microp.winners.charts.create).toEqual(jasmine.any(Object));
  		expect(microp.winners.charts.create).not.toEqual(jasmine.any(Function));
  	})
  })

	describe('top metrics', function() {
		it('has the correct number of vendors who have placed bids', function() {
			winners.charts.create.metrics(auctions)
			expect(auctions.length).toEqual(4);
			expect(winners.metrics.$auctions_total).toEqual(4)
		})

		it('has the correct number of unique winners', function() {
			winners.charts.create.metrics(auctions)
			expect(winners.metrics.$unique_winners).toEqual(3)
		})

		it('has the correct average winning bid', function() {
			winners.charts.create.metrics(auctions)
			expect(winners.metrics.$winning_bid).toEqual('$2,113')
		})

		it('has the correct number of vendors', function() {
			winners.charts.create.metrics(auctions)
			expect(winners.metrics.$bidding_vendors).toEqual(8)
		})

		it('has the correct number of bids/auction', function() {
			winners.charts.create.metrics(auctions)
			expect(winners.metrics.$bids).toEqual(3.3)
		})

		it('has the correct length for a typical auction', function() {
			winners.charts.create.metrics(auctions)
			expect(winners.metrics.$auction_length).toEqual('7.3 days')
		})
	})

	describe('donut 1 data', function () {
		beforeEach(function(){
			settings = winners.charts.create.donut1(auctions)
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
			expect(settings).toEqual(jasmine.any(Object));
			expect(settings.cols).toEqual(jasmine.any(Object));
			expect(settings.cols).toEqual(jasmine.any(Array));
		})

		it('the array has the correct objects', function(){
			expect(settings).toEqual(matcher);
		})
	})

	describe('donut 2 data', function () {
		beforeEach(function(){
			settings = winners.charts.create.donut2(auctions)
			matcher = {
				"cols":[
					["google sheets",1],
					["ruby",2],
					["python",2],
					["yml",1],
					[]
				]
			}
		})

		it('is returning an object', function(){
			expect(settings).toEqual(jasmine.any(Object));
			expect(settings.cols).toEqual(jasmine.any(Object));
			expect(settings.cols).toEqual(jasmine.any(Array));
		})

		it('the array has the correct objects', function(){
			expect(settings).toEqual(matcher);
		})
	})

	describe('chart 2 data', function () {
		beforeEach(function(){
			settings = winners.charts.create.chart2(auctions)
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
			expect(settings).toEqual(matcher);
		})

		it('correct number of columns', function(){
			expect(settings.cols.length).toEqual(4);
		})
	})

	describe('chart 4 data', function () {
		beforeEach(function(){
			settings = winners.charts.create.chart4(auctions)
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
			expect(settings).toEqual(matcher);
		})

		it('correct number of columns', function(){
			expect(settings.cols.length).toEqual(4);
		})

		it('correct x attribute', function(){
			expect(settings.x).toEqual(matcher.x);
		})
	})

	describe('chart 5 data', function () {
		beforeEach(function(){
			settings = winners.charts.create.chart5(auctions)
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
					"18":3000,
					"21":250,
					"22":3200,
					"23":2000
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
			expect(settings).toEqual(matcher);
		})

		it('winning bids are correct', function(){
			expect(settings.z).toEqual(matcher.z);
		})

		it('dates are correct', function(){
			expect(settings.xs).toEqual(matcher.xs);
		})
	})

});
