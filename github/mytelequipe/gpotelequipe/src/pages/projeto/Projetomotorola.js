import { useState, useEffect } from 'react';
import Notpermission from '../../layouts/notpermission/notpermission';

const Projetomotorola = () => {
  const [permission, setpermission] = useState(0);

  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.motorola === 1);
  }
  useEffect(() => {
    userpermission();
  }, []);
  return (
    <div>
      {permission && (
        <div className="home">
          <h1>Projetos</h1>
        </div>
      )}
      {!permission && <Notpermission />}
    </div>
  );
};

export default Projetomotorola;
