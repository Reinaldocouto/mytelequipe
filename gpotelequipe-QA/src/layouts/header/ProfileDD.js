import React  from 'react';
import user1 from '../../assets/images/users/user4.jpg';

const ProfileDD = () => {

  const getEmail = localStorage.getItem('sessionEmail');
  const getNome = localStorage.getItem('sessionNome');

  return (
    <>

      <div>
        <div className="d-flex gap-3 p-3 border-bottom pt-2 align-items-center ">
          <img src={user1} alt="user" className="rounded-circle" width="60" />
          <span>
            <h5 className="mb-0">{getNome}</h5>
            <small className="fs-6 text-muted">{getEmail}</small>
          </span>
        </div>
      </div>
    </>
  );
};

export default ProfileDD;
