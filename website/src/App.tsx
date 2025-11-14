import React from 'react';
import { AppStateProvider } from './app/providers/app_state_provider';
import { AuthInitializer } from './features/auth/presentation/components/AuthInitializer';
import { AppRoutes } from './routes';

const App: React.FC = () => {
  return (
    <AuthInitializer>
      <AppStateProvider>
        <AppRoutes />
      </AppStateProvider>
    </AuthInitializer>
  );
};

export default App;
