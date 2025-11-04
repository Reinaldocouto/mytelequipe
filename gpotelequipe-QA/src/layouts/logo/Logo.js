import { Link } from 'react-router-dom';
import React from 'react';
import {
  UncontrolledDropdown,
  DropdownToggle,
} from 'reactstrap';
//import logo from '../../assets/images/logos/logo.png';
import logotelequipe from '../../assets/images/logos/logotelequipe.png';

const Logo = () => {
  return (
    <Link to="/" className="d-flex align-items-center gap-2">
      <UncontrolledDropdown className=" hov-dd">
        <DropdownToggle color="transparent">
          <img src={logotelequipe} alt="" className="" width="210" />
        </DropdownToggle>
      </UncontrolledDropdown>
    </Link>
  );
};

export default Logo;


