import React from 'react';
import { Row, Col, Card, CardBody } from 'reactstrap';

const Demonstrativoheader = () => {
  return (
    <Row>
      <Col lg="3">
        <Card
          color="primary"
          className="text-white text-center cursor-pointer"
          onClick={null}
        >
          <CardBody>
            <h2>POItem</h2>
            <h5>Total Tickets</h5>
          </CardBody>
        </Card>
      </Col>
      <Col lg="3">
        <Card
          color="warning"
          className="text-white text-center cursor-pointer"
          onClick={null}
        >
          <CardBody>
            <h2>PO</h2>
            <h5>Pending Tickets</h5>
          </CardBody>
        </Card>
      </Col>
      <Col lg="3">
        <Card
          color="success"
          className="text-white text-center cursor-pointer"
          onClick={null}
        >
          <CardBody>
            <h2>ObraID</h2>
            <h5>Open Tickets</h5>
          </CardBody>
        </Card>
      </Col>
      <Col lg="3">
        <Card
          color="danger"
          className="text-white text-center cursor-pointer"
          onClick={null}
        >
          <CardBody>
            <h2>0</h2>
            <h5>Closed Tickets</h5>
          </CardBody>
        </Card>
      </Col>
    </Row>
  );
};

export default Demonstrativoheader;