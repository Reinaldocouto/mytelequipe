import { Link } from 'react-router-dom';
import React from 'react';
import {
  UncontrolledDropdown,
  DropdownToggle,
} from 'reactstrap';
import logo from '../../assets/images/logos/logo.png';

const Logoinferior = () => {
  return (
    <Link to="/" className="d-flex align-items-center gap-2">
      <UncontrolledDropdown className=" hov-dd">
        <DropdownToggle color="transparent">
          <img src={logo} alt="" className="" width="210" />
        </DropdownToggle>
      </UncontrolledDropdown>
    </Link>
  );
};

export default Logoinferior;
