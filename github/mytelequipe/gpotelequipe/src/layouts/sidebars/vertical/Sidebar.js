import { Nav } from 'reactstrap';
import { useLocation } from 'react-router-dom';
import { useSelector } from 'react-redux';
import SimpleBar from 'simplebar-react';
import SidebarData from '../sidebardata/SidebarData';
import Logo from '../../logo/Logo';
//import Logoinferior from '../../logo/Logoinferior'
import NavItemContainer from './NavItemContainer';
import NavSubMenu from './NavSubMenu';

const Sidebar = () => {
  const location = useLocation();
  const currentURL = location.pathname.split('/').slice(0, -1).join('/');

  //const [collapsed, setCollapsed] = useState(null);
  // const toggle = (index) => {
  //   setCollapsed(collapsed === index ? null : index);
  // };

  const activeBg = useSelector((state) => state.customizer.sidebarBg);
  const isFixed = useSelector((state) => state.customizer.isSidebarFixed);
  const menuItems = SidebarData();
  return (
    <div className={`sidebarBox shadow bg-${activeBg} ${isFixed ? 'fixedSidebar' : ''}`}>
      <SimpleBar style={{ height: '100%' }}>
        {/********Logo*******/}
        <div className="d-flex p-3 align-items-center">
          <Logo />
        </div>
        {/********Sidebar Content*******/}
        <div className="p-3 pt-1 mt-2">
          <Nav vertical className={activeBg === 'white' ? '' : 'lightText'}>
            {menuItems?.map((navi, index) => {
              if (navi.caption) {
                return (
                  <div className="navCaption text-uppercase mt-4" key={`caption-${navi.id}`}>
                    {navi.caption}
                  </div>
                );
              }
              if (navi.children) {
                return (
                  <NavSubMenu
                    key={`subMenu_${navi.id + index}`}
                    icon={navi.icon}
                    title={navi.title}
                    items={navi.children}
                    suffix={navi.suffix}
                    suffixColor={navi.suffixColor}
                    // toggle={() => toggle(navi.id)}
                    // collapsed={collapsed === navi.id}
                    isUrl={currentURL === navi.href}
                  />
                );
              }
              return (
                <NavItemContainer
                  key={`navItem_${navi.id}`}
                  //toggle={() => toggle(navi.id)}
                  className={location.pathname === navi.href ? 'activeLink' : ''}
                  to={navi.href}
                  title={navi.title}
                  suffix={navi.suffix}
                  suffixColor={navi.suffixColor}
                  icon={navi.icon}
                />
              );
            })}
          </Nav>
        </div>
      </SimpleBar>
    </div>
  );
};

export default Sidebar;
