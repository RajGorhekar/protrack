import Dashboard from 'views/Dashboard.js';
import Notifications from 'views/Notifications.js';
import UserProfile from 'views/UserProfile.js';

var routes = [
  {
    path: '/dashboard',
    name: 'Dashboard',
    icon: 'tim-icons icon-chart-pie-36',
    component: Dashboard,
    layout: '/admin',
  },
  {
    path: '/notifications',
    name: 'Tasks',
    icon: 'tim-icons icon-bell-55',
    component: Notifications,
    layout: '/admin',
  },
  {
    path: '/user-profile',
    name: 'User Profile',
    icon: 'tim-icons icon-single-02',
    component: UserProfile,
    layout: '/admin',
  },
];
export default routes;
