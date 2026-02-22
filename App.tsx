import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import IntersectObserver from '@/components/common/IntersectObserver';
import { Toaster } from '@/components/ui/sonner';
import { AuthProvider } from '@/contexts/AuthContext';
import { RouteGuard } from '@/components/common/RouteGuard';
import AppLayout from '@/components/layouts/AppLayout';
import routes from './routes';

const AppContent: React.FC = () => {
  return (
    <RouteGuard>
      <IntersectObserver />
      <Routes>
        {routes.map((route, index) => {
          const isPublic = ['/login', '/signup'].includes(route.path);
          return (
            <Route
              key={index}
              path={route.path}
              element={
                isPublic ? (
                  route.element
                ) : (
                  <AppLayout>{route.element}</AppLayout>
                )
              }
            />
          );
        })}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
      <Toaster position="top-center" />
    </RouteGuard>
  );
};

const App: React.FC = () => {
  return (
    <Router>
      <AuthProvider>
        <AppContent />
      </AuthProvider>
    </Router>
  );
};

export default App;
