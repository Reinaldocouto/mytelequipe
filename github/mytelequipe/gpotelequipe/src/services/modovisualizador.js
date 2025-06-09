const modoVisualizador = () => {
  try {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    return permissionstorage?.modovisualizador === 1;
  } catch (error) {
    console.error('Error reading viewer mode:', error);
    return false;
  }
};

export default modoVisualizador;
