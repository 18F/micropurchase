if (Meteor.isClient) {
  Template.index.helpers({
    opportunities: [
      {
        title: 'The title',
        url: 'https://18f.gsa.gov',
        currentBid: 10,
        closingDate: '5:00 PM EST, November 1, 2015'
      },
      {
        title: 'The title',
        url: 'https://18f.gsa.gov',
        currentBid: 10,
        closingDate: '5:00 PM EST, November 1, 2015'
      },
      {
        title: 'The title',
        url: 'https://18f.gsa.gov',
        currentBid: 10,
        closingDate: '5:00 PM EST, November 1, 2015'
      },
      {
        title: 'The title',
        url: 'https://18f.gsa.gov',
        currentBid: 10,
        closingDate: '5:00 PM EST, November 1, 2015'
      }
    ]
  });
}
