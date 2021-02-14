var redux = require('redux');
var oldState = {
  productiveData: {},
  unProductiveData: {},
  email: 'jyotigorherkar@gmail.com',
  task: [],
};

let whiteList = [
  'Visual Studio Code',
  'Eclipse',
  'Adobe XD',
  'WPS Office',
  'Word',
  'Powerpoint',
  'Adobe Acrobat Reader DC (32-bit)',
  'Windows PowerShell',
  'Android Studio',
  'Code::Blocks 17.12',
  'Sublime Text (UNREGISTERED)',
  'Postman',
  'Excel',
  'Zoom Cloud Meetings',
  'airmeet.com',
  'meet.google.com',
  'mail.google.com',
  'console.firebase.google.com',
];
let blackList = [
  'μTorrent 3.5.5',
  'mxplayer.in',
  'hatchful.shopify.com',
  'primevideo.com',
  'instagram.com',
  'facebook.com',
  'netflix.com',
  'flipkart.com',
  'myntra.com',
  'ajio.com',
  'olacabs.com',
  'uber.com',
  'facebook.com',
  'amazon.in',
];

const reducer = (state = oldState, action) => {
  const { type, payload } = action;
  switch (type) {
    case 'USER_INFO':
      return { ...state };
    case 'GET_DATA':
      // console.log(payload);
      var labels_productive = [];
      var time_map_productive = [];
      var labels_unproductive = [];
      var time_map_unproductive = [];
      payload.data.forEach((element) => {
        if (whiteList.includes(element.name)) {
          let minutes = 0;
          labels_productive.push(element.name);
          element.time_entries.forEach((timeEntry) => {
            minutes +=
              timeEntry.hours * 60 + timeEntry.minutes + timeEntry.seconds / 60;
          });
          time_map_productive.push(Math.ceil(minutes));
          // console.log(labels_productive, time_map_productive);
        } else if (blackList.includes(element.name)) {
          let minutes = 0;
          labels_unproductive.push(element.name);
          element.time_entries.forEach((timeEntry) => {
            minutes +=
              timeEntry.hours * 60 + timeEntry.minutes + timeEntry.seconds / 60;
          });
          time_map_unproductive.push(Math.ceil(minutes));
          // console.log(labels_unproductive, time_map_unproductive);
        }
      });
      return {
        ...state,
        productiveData: {
          labels: labels_productive,
          time_map: time_map_productive,
        },
        unProductiveData: {
          labels: labels_unproductive,
          time_map: time_map_unproductive,
        },
        loading: false,
      };
    case 'SET_EMAIL':
      console.log(payload);
      return {
        ...state,
        email: payload,
      };
    default:
      return state;
  }
};
var store = redux.createStore(reducer);
export default store;
