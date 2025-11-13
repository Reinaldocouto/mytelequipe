import React, { Suspense } from 'react';
import { useRoutes } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { createTheme, ThemeProvider, useTheme } from '@mui/material/styles';
import * as locales from '@mui/material/locale';
import Themeroutes from './routes/Router';
import ThemeSelector from './layouts/theme/ThemeSelector';
import Loader from './layouts/loader/Loader';

const App = () => {
  const routing = useRoutes(Themeroutes);
  const direction = useSelector((state) => state.customizer.isRTL);
  const isMode = useSelector((state) => state.customizer.isDark);

  const [locale, setLocale] = React.useState('pt_BR');
  console.info(setLocale);
  const theme = useTheme();

  const themeWithLocale = React.useMemo(() => createTheme(theme, locales[locale]), [locale, theme]);

  return (
    <ThemeProvider theme={themeWithLocale}>
      <Suspense fallback={<Loader />}>
        <div
          className={`${direction ? 'rtl' : 'ltr'} ${isMode ? 'dark' : ''}`}
          dir={direction ? 'rtl' : 'ltr'}
        >
          <ThemeSelector />
          {routing}
        </div>
      </Suspense>
    </ThemeProvider>
  );
};

export default App;
