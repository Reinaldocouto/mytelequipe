import React from 'react';
import PropTypes from 'prop-types';
import { Card, CardBody } from 'reactstrap';
import './IndicadorCard.css';

const IndicadorCard = ({ data }) => {
  return (
    <Card className="text-center indicador-card">
      <CardBody className="indicador-card-body">
        <div className="d-flex flex-column align-items-center">
          <h5 className="indicador-card-title">{data.title}</h5>
          <div className="d-flex justify-content-center">
            {data.values.map((item) => (
              <div key={`${item.label}-${item.value}`} className="indicador-card-value mx-2">
                <h2>{item.value}</h2>
                <p>{item.label}</p>
              </div>
            ))}
          </div>
        </div>
      </CardBody>
    </Card>
  );
};

IndicadorCard.propTypes = {
  data: PropTypes.shape({
    title: PropTypes.string.isRequired,
    values: PropTypes.arrayOf(
      PropTypes.shape({
        label: PropTypes.string.isRequired,
        value: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
      })
    ).isRequired,
  }).isRequired,
};

export default IndicadorCard;