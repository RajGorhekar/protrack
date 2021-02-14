import React from 'react';
import { Route, Switch, Redirect, useLocation } from 'react-router-dom';
import PerfectScrollbar from 'perfect-scrollbar';
import AdminNavbar from 'components/Navbars/AdminNavbar.js';
import Sidebar from 'components/Sidebar/Sidebar.js';
import FixedPlugin from 'components/FixedPlugin/FixedPlugin.js';
import routes from 'routes.js';
import { BackgroundColorContext } from 'contexts/BackgroundColorContext';
import firebase from 'firebase';
import { connect } from 'react-redux';
import store from '../../Store';

var ps;

const firebaseConfig = {
  apiKey: 'AIzaSyBidmWcE6iwL_Orhy5WszqfZNVJYuuQW7A',
  authDomain: 'spit-hack-21.firebaseapp.com',
  projectId: 'spit-hack-21',
  storageBucket: 'spit-hack-21.appspot.com',
  messagingSenderId: '791127523502',
  appId: '1:791127523502:web:8766ec62c62446c9bced3f',
  measurementId: 'G-MZJDLGVHZV',
};

firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();
const auth = firebase.auth();

function Admin(props) {
  const location = useLocation();
  const mainPanelRef = React.useRef(null);
  const [sidebarOpened, setsidebarOpened] = React.useState(
    document.documentElement.className.indexOf('nav-open') !== -1
  );
  React.useEffect(() => {
    if (navigator.platform.indexOf('Win') > -1) {
      document.documentElement.className += ' perfect-scrollbar-on';
      document.documentElement.classList.remove('perfect-scrollbar-off');
      ps = new PerfectScrollbar(mainPanelRef.current, {
        suppressScrollX: true,
      });
      let tables = document.querySelectorAll('.table-responsive');
      for (let i = 0; i < tables.length; i++) {
        ps = new PerfectScrollbar(tables[i]);
      }
    }
    return function cleanup() {
      if (navigator.platform.indexOf('Win') > -1) {
        ps.destroy();
        document.documentElement.classList.add('perfect-scrollbar-off');
        document.documentElement.classList.remove('perfect-scrollbar-on');
      }
    };
  });
  React.useEffect(() => {
    if (navigator.platform.indexOf('Win') > -1) {
      let tables = document.querySelectorAll('.table-responsive');
      for (let i = 0; i < tables.length; i++) {
        ps = new PerfectScrollbar(tables[i]);
      }
    }
    document.documentElement.scrollTop = 0;
    document.scrollingElement.scrollTop = 0;
    if (mainPanelRef.current) {
      mainPanelRef.current.scrollTop = 0;
    }
  }, [location]);

  function get_Date() {
    var d = new Date(),
      month = '' + (d.getMonth() + 1),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
  }

  // console.log(store.getState().email);

  React.useEffect(() => {
    db.collection(store.getState().email)
      .doc('activity')
      .get()
      .then((doc) => {
        if (!doc.exists) {
          console.log('No such document!');
        } else {
          const date = get_Date();
          var data = doc.data()['Date'][`${date}`].activities;
        }
        props.dispatch({
          type: 'GET_DATA',
          payload: { data },
        });
      });
  }, [store.getState().email]);

  const toggleSidebar = () => {
    document.documentElement.classList.toggle('nav-open');
    setsidebarOpened(!sidebarOpened);
  };

  const getRoutes = (routes) => {
    return routes.map((prop, key) => {
      if (prop.layout === '/admin') {
        return (
          <Route
            path={prop.layout + prop.path}
            component={prop.component}
            key={key}
          />
        );
      } else {
        return null;
      }
    });
  };
  const getBrandText = (path) => {
    for (let i = 0; i < routes.length; i++) {
      if (location.pathname.indexOf(routes[i].layout + routes[i].path) !== -1) {
        return routes[i].name;
      }
    }
    return 'Brand';
  };
  return (
    <BackgroundColorContext.Consumer>
      {({ color, changeColor }) => (
        <React.Fragment>
          <div className='wrapper'>
            <Sidebar routes={routes} toggleSidebar={toggleSidebar} />
            <div className='main-panel' ref={mainPanelRef} data={color}>
              <AdminNavbar
                brandText={getBrandText(location.pathname)}
                toggleSidebar={toggleSidebar}
                sidebarOpened={sidebarOpened}
              />
              <Switch>
                {getRoutes(routes)}
                <Redirect from='*' to='/admin/dashboard' />
              </Switch>
              {location.pathname === '/admin/maps'}
            </div>
          </div>
          {/* <FixedPlugin bgColor={color} handleBgClick={changeColor} /> */}
        </React.Fragment>
      )}
    </BackgroundColorContext.Consumer>
  );
}

const mapStateToProps = (state, ownProps) => {
  return {
    lineData: state.lineData,
  };
};
export default connect(mapStateToProps)(Admin);
