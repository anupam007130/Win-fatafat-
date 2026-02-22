import Dashboard from './pages/Dashboard';
import Login from './pages/Login';
import Signup from './pages/Signup';
import Wallet from './pages/Wallet';
import GamesList from './pages/GamesList';
import BetGame from './pages/BetGame';
import History from './pages/History';
import Results from './pages/Results';

import Rules from './pages/Rules';
import Support from './pages/Support';
import Settings from './pages/Settings';
import AdminOverview from './pages/AdminOverview';
import AdminUsers from './pages/AdminUsers';
import AdminGames from './pages/AdminGames';
import AdminRecharges from './pages/AdminRecharges';
import AdminWithdrawals from './pages/AdminWithdrawals';
import AdminPendingBets from './pages/AdminPendingBets';
import AdminSettings from './pages/AdminSettings';
import type { ReactNode } from 'react';

interface RouteConfig {
  name: string;
  path: string;
  element: ReactNode;
  visible?: boolean;
}

const routes: RouteConfig[] = [
  { name: 'Login', path: '/login', element: <Login /> },
  { name: 'Signup', path: '/signup', element: <Signup /> },
  { name: 'Dashboard', path: '/dashboard', element: <Dashboard /> },
  { name: 'Wallet', path: '/wallet', element: <Wallet /> },
  { name: 'Games', path: '/games', element: <GamesList /> },
  { name: 'Results', path: '/results', element: <Results /> },

  { name: 'Play Game', path: '/games/:id', element: <BetGame /> },
  { name: 'History', path: '/history', element: <History /> },
  { name: 'Rules', path: '/rules', element: <Rules /> },
  { name: 'Support', path: '/support', element: <Support /> },
  { name: 'Settings', path: '/settings', element: <Settings /> },
  
  // Admin Routes
  { name: 'Admin Overview', path: '/admin', element: <AdminOverview /> },
  { name: 'Manage Users', path: '/admin/users', element: <AdminUsers /> },
  { name: 'Manage Games', path: '/admin/games', element: <AdminGames /> },
  { name: 'Recharges', path: '/admin/recharges', element: <AdminRecharges /> },
  { name: 'Withdrawals', path: '/admin/withdrawals', element: <AdminWithdrawals /> },
  { name: 'Pending Bets', path: '/admin/pending-bets', element: <AdminPendingBets /> },
  { name: 'Admin Settings', path: '/admin/settings', element: <AdminSettings /> },
  
  // Default Redirect
  { name: 'Home', path: '/', element: <Dashboard /> },
];

export default routes;
