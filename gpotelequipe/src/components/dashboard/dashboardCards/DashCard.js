import { Card, CardBody, CardTitle, CardSubtitle, FormGroup, Label, Input } from 'reactstrap';
import PropTypes from 'prop-types';

const DashCard = ({ children, title, subtitle, showDateFilter = false }) => {
  const handleDateChange = (event) => {
    console.log(event.target.value);
  };

  return (
    <Card>
      <CardBody style={{ backgroundColor: 'white' }}>
        <div className="d-flex justify-content-between align-items-start">
          <div>
            <CardTitle tag="h4">{title}</CardTitle>
            <CardSubtitle className="text-muted">{subtitle}</CardSubtitle>
          </div>
          {showDateFilter && (
            <FormGroup style={{ width: '200px' }}>
              <Label for="dateFilter" className="visually-hidden">Filtrar por Data</Label>
              <Input
                type="date"
                name="date"
                id="dateFilter"
                onChange={handleDateChange}
              />
            </FormGroup>
          )}
        </div>
        {children}
      </CardBody>
    </Card>
  );
};

DashCard.propTypes = {
  children: PropTypes.node,
  title: PropTypes.string,
  subtitle: PropTypes.string,
  showDateFilter: PropTypes.bool,
};

export default DashCard;
