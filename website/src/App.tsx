import React from 'react';
import { AppStateProvider } from './app/providers/app_state_provider';
import { AppRoutes } from './routes';

const App: React.FC = () => {
  return (
    <AppStateProvider>
      <AppRoutes />
    </AppStateProvider>
  );
};

export default App;
