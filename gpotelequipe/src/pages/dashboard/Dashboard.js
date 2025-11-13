import { Row, Col } from 'reactstrap';
import BreadCrumbs from '../../layouts/breadcrumbs/BreadCrumbs';
//import ProjectTable from '../../components/dashboard/modernDashboard/ProjectTable';
//import WeatherReport from '../../components/dashboard/modernDashboard/WeatherReport';
//import RecentMessages from '../../components/dashboard/modernDashboard/RecentMessages';
//import TaskList from '../../components/dashboard/minimalDashboard/TaskList';
import TreinamentoHorizontal from '../../components/dashboard/Dashboards/TreinamentoHorizontal';
import VeiculosAtivosPorCategoria from '../../components/dashboard/veiculos/VeiculosAtivosPorCategoria';
import Treinamento from '../../components/dashboard/Dashboards/Treinamento';
import VeiculosInspecaoPeriodica from '../../components/dashboard/veiculos/VeiculosInspecaoPeriodica'
//import IncomeYear from '../../components/dashboard/minimalDashboard/IncomeYear';
import IndicadorInspecao from '../../components/dashboard/Dashboards/IndicadorInspecao';
import Isignum from '../../components/dashboard/Dashboards/Isignum';
import IndicadorCnh from '../../components/dashboard/Dashboards/IndicadorCnh';

//graficos não implementados
/*<Row>
<IndicadorInspecao />
</Row>
<Col lg="6">
         <DistribuicaoAlerta />
</Col> */


const Dashboard = () => {
  return (
    <>
      <BreadCrumbs />

      {/********************* Treinamento ************************/}

      <Row>
        <Col lg="12">
          <TreinamentoHorizontal />
        </Col>
      </Row>

      {/********************* Treinamento e Isignum ************************/}
      <Row>
        <Col lg="12">
          <VeiculosAtivosPorCategoria />
        </Col>
      </Row>
      <Row>
        <Col lg="12">
          <VeiculosInspecaoPeriodica />
        </Col>
      </Row>
      <Row>
        <Col lg="6">
          <IndicadorInspecao />
        </Col>
        <Col lg="6">
          <IndicadorCnh />
        </Col>
      </Row>
      <Row>
        <Col lg="6">
          <Isignum />
        </Col>
        <Col lg="6">
          <Treinamento />
        </Col>
      </Row>

      {/*********************Project Table ************************/}
      {/*
      <Row>
        <Col lg="8">
          <ProjectTable />
        </Col>
        <Col lg="4">
          <WeatherReport />
        </Col>
      </Row>
      <Row>
        <Col lg="6">
          <RecentMessages />
        </Col>
        <Col lg="6">
          <TaskList />
        </Col>
      </Row> */}
    </>
  );
};

export default Dashboard;