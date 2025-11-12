import React from 'react';
import {
  UncontrolledDropdown,
  DropdownToggle,
} from 'reactstrap';
import logotelequipe from '../../assets/images/logos/logotelequipe.png';

const AuthLogo = () => {
  return (
    <div className="p-4 d-flex justify-content-center gap-2">
      <UncontrolledDropdown className=" hov-dd">
        <DropdownToggle color="transparent">
          <img src={logotelequipe} alt="" className="" width="210" />
        </DropdownToggle>
      </UncontrolledDropdown>
    </div>
  );
};

export default AuthLogo;
