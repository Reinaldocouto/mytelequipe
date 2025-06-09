const modofinanceiro = () => {
    try {
      const permissionstorage = JSON.parse(localStorage.getItem('permission'));
      return permissionstorage?.telefonicafechamento === 1;
    } catch (error) {
      console.error('Error reading viewer mode:', error);
      return false;
    }
  };
  
  export default modofinanceiro;