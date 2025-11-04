import React from 'react';
import { Row } from 'reactstrap';

import ProgressCardsData from './ProgressCardsData';

const ProgressCards = () => {
  return (
    /*--------------------------------------------------------------------------------*/
    /* Reviews                                                 */
    /*--------------------------------------------------------------------------------*/
    <Row>
      <ProgressCardsData
        title= "Daily Sales"
        income="120"
        icon= "arrow-down-short"
        pColor="success"
        subtext="Todays Income"
        pPercent="80"
      />
      <ProgressCardsData
        title= "Weekly Sales"
        income="5,000"
        icon= "arrow-up-short"
        pColor="primary"
        subtext="Todays Income"
        pPercent="30"
      />
      <ProgressCardsData
        title= "Monthly Sales"
        income="8,000"
        icon= "arrow-up-short"
        pColor="info"
        subtext="Todays Income"
        pPercent="60"
      />
      <ProgressCardsData
        title= "Yearly Sales"
        income="12,000"
        icon= "arrow-down-short"
        pColor="danger"
        subtext="Todays Income"
        pPercent="80"
      />
    </Row>
  );
};

export default ProgressCards;
