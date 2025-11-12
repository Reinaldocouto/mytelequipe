import { Table } from 'reactstrap';
//import Chart from 'react-apexcharts';
import PropTypes from 'prop-types';

//-------------------------
// Doughnut Chart
//-------------------------
/* const optionsdoughnut = {
  chart: {
    id: 'donut-chart',
    fontFamily: "'Rubik', sans-serif",
  },
  dataLabels: {
    enabled: true,
  },
  plotOptions: {
    pie: {
      donut: {
        size: '70px',
      },
    },
  },
  legend: {
    show: true,
    position: 'bottom',
    width: '50px',
    fontFamily: "'Montserrat', sans-serif",
    labels: {
      colors: '#8898aa',
    },
  },
  colors: [
    'rgb(30, 136, 229)',
    'rgb(38, 198, 218)',
    'rgb(236, 239, 241)',
    'rgb(116, 90, 242)',
    '#ef5350',
  ],
  tooltip: {
    fillSeriesColor: false,
    theme: 'dark',
  },
}; */

/*        <div className="row g-3">
          <div className="col-sm-3">
            <br></br>
            <br></br>
            <br></br>
            Recebimento
            <br></br>
            <h1>{totalrecebimento}</h1>
            <h6 className="text-muted">Total POs ativas</h6>
          </div>

          <div className="col-sm-3">
            Status Migo
            <Chart options={optionsdoughnut} series={statusmigo} type="donut" height="300" />
          </div>
          <div className="col-sm-3">
            Com Migo por Tipo
            <Chart options={optionsdoughnut} series={migoportipo} type="donut" height="300" />
          </div>
          <div className="col-sm-3">
            Sem Migo por Tipo
            <Chart options={optionsdoughnut} series={semmigoportipo} type="donut" height="300" />
          </div>
        </div>  */

const Demonstrativores = ({
  tabelademonstra,
  tabelaofensor,
  //  semmigoportipo,
  //  migoportipo,
  //  totalrecebimento,
  //  statusmigo,
}) => {

  const totalFaturar = tabelademonstra.reduce((acc, item) => acc + item.faturarn, 0);

  return (
    <>
      <div className="p-4 ">
        <div>

          <Table bordered sm={12} className="table-light w-100" style={{ width: '100%' }}>
            <thead>
              <tr>
                <th>Cliente</th>
                <th>RFP</th>
                <th>Emitido</th>
                <th>SemMIGO</th>
                <th>comMIGO</th>
                <th>Faturar</th>
              </tr>
            </thead>


            <tbody>
              {tabelademonstra.map((item) => (
                <tr >
                  <td>{item.cliente}</td>
                  <td>{item.rfp}</td>
                  <td>{item.emitidos}</td>
                  <td>{item.semmigo}</td>
                  <td>{item.commigo}</td>
                  <td>{item.faturar}</td>

                </tr>
              ))}
            </tbody>
            <tbody>
              <tr >
                <td><strong>TOTAL</strong></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td><strong>{totalFaturar.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}</strong></td>
              </tr>
            </tbody>
          </Table>
        </div>



        {/*<EnhancedTable data={tabelademonstra} /> */}

        {/* <div>
            <Select
              isClearable
              //components={{ Control: ControlComponent }}
              isSearchable
              name="Status PO"
              options={[]}
              onChange={null}
              value={null}
              placeholder="Selecione"
            />
          </div>  */}
        <Table bordered className="table-light" style={{ width: '100%' }}>
          <thead>
            <tr>
              <th>Status PO</th>
              <th>Valor</th>
            </tr>
          </thead>
          <tbody>
            {tabelaofensor.map((item) => (
              <tr >
                <td>{item.statuspo}</td>
                <td>{item.valor}</td>
              </tr>
            ))}
          </tbody>
        </Table>



      </div>
    </>
  );
};

Demonstrativores.propTypes = {
  //semmigoportipo: PropTypes.any,
  tabelademonstra: PropTypes.any,
  //migoportipo: PropTypes.any,
  //totalrecebimento: PropTypes.any,
  tabelaofensor: PropTypes.any,
  //statusmigo: PropTypes.any,
};

export default Demonstrativores;