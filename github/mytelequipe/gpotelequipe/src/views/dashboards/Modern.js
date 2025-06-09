import { Row, Col } from 'reactstrap';
import BreadCrumbs from '../../layouts/breadcrumbs/BreadCrumbs';

import ProgressCards from '../../components/dashboard/modernDashboard/ProgressCards';
import RevenueStatistics from '../../components/dashboard/modernDashboard/RevenueStatistics';
import SalesMonth from '../../components/dashboard/modernDashboard/SalesMonth';
import SalesPrediction from '../../components/dashboard/modernDashboard/SalesPrediction';
import SalesDifference from '../../components/dashboard/modernDashboard/SalesDifference';
import ProfileCard from '../../components/dashboard/modernDashboard/ProfileCard';

const Classic = () => {
  return (
    <>
    <BreadCrumbs />
      <ProgressCards />
      <RevenueStatistics />
      <Row>
        <Col lg="4">
          <SalesMonth />
        </Col>
        <Col lg="4">
          <SalesPrediction />
          <SalesDifference />
        </Col>
        <Col lg="4">
          <ProfileCard />
        </Col>
      </Row>
    </>
  );
};

export default Classic;
