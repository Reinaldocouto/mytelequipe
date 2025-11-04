// eslint-disable-next-line import/no-extraneous-dependencies
import { Stack } from 'rsuite';
//import moment from 'moment';
import { Input } from 'reactstrap';
import PropTypes from 'prop-types';

const Demonstrativofiltro = ({ pesquisar }) => {
 /* const ranges = [
    {
      label: 'Últimos 7 dias',
      value: [moment().subtract(6, 'days').startOf('day').toDate(), moment().endOf('day').toDate()],
    },
    {
      label: 'Últimos 30 dias',
      value: [
        moment().subtract(29, 'days').startOf('day').toDate(),
        moment().endOf('day').toDate(),
      ],
    },
    {
      label: 'Últimos 60 dias',
      value: [
        moment().subtract(59, 'days').startOf('day').toDate(),
        moment().endOf('day').toDate(),
      ],
    },
  ]; */
  return (
    <div>
      <Stack spacing={8} direction="column" alignItems="flex-center">

        <div className="p-3" style={{ borderBottom: '1px solid #ccc' }}>
          <h6 className="mb-2">RFP</h6>
          <div className="row g-3">
            <div className="col-sm-12">
              <Input
                type="select"
                name="rfp"
                onChange={(event) => {
                  pesquisar({ rfp: event.target.value });
                }}
              >
                <option value="todos">Selecione</option>
                <option value="2019">2019</option>
                <option value="2020">2020</option>
                <option value="2022">2022</option>
                <option value="2024">2024</option>                                
              </Input>
            </div>
          </div>
        </div>


        <div className="p-3" style={{ borderBottom: '1px solid #ccc' }}>
          <h6 className="mb-2">Cliente</h6>
          <div className="row g-3">
            <div className="col-sm-12">
              <Input
                type="select"
                name="cliente"
                onChange={(event) => {
                  pesquisar({ cliente: event.target.value });
                }}
              >
                <option value="">Selecione</option>
                <option value="CLARO">CLARO</option>
                <option value="TIM">TIM</option>
                <option value="VIVO">VIVO</option>
              </Input>
            </div>
          </div>
        </div>

        <div className="p-3" style={{ borderBottom: '1px solid #ccc' }}>
          <h6 className="mb-2">Regional</h6>
          <div className="row g-3">
            <div className="col-sm-12">
              <Input
                type="select"
                name="regional"
                onChange={(event) => {
                  pesquisar({ regiona: event.target.value });
                }}
              >
                <option value="">Selecione</option>
                <option value="RSU MG">RSU MG</option>
                <option value="RSU NE">RSU NE</option>
                <option value="RSU RJ/ES">RSU RJ/ES</option>
                <option value="RSU SPC">RSU SPC</option>
                <option value="RSU SPI">RSU SPI</option>
              </Input>
            </div>
          </div>
        </div>

        <div className="p-3" style={{ borderBottom: '1px solid #ccc' }}>
          <h6 className="mb-2">Site</h6>
          <div className="row g-3">
            <div className="col-sm-12">
              <Input
                type="text"
                name="site"
                onChange={(event) => {
                  pesquisar({ site: event.target.value });
                }}
              >
              </Input>
            </div>
          </div>
        </div>
        {/* 
        <div className="p-3" style={{ borderBottom: '1px solid #ccc' }}>
          <h6 className="mb-2">Tipo de Obra</h6>
          <div className="row g-3">
            <div className="col-sm-12">
              <Input
                type="select"
                name="tipoObra"
                onChange={(event) => {
                  pesquisar({ tipoObra: event.target.value });
                }}
              >
                <option value="Selecione">Selecione</option>
                <option value="CLARO">CLARO</option>
                <option value="TIM">TIM</option>
                <option value="VIVO">VIVO</option>
              </Input>
            </div>
          </div>
        </div>

        <div className="p-3" style={{ borderBottom: '1px solid #ccc' }}>
          <h6 className="mb-2">Escopo</h6>
          <div className="row g-3">
            <div className="col-sm-12">
              <Input
                type="text"
                name="escopo"
                onChange={(event) => {
                  pesquisar({ escoponome: event.target.value });
                }}
              >
              </Input>
            </div>
          </div>
        </div>              */}
      </Stack>
    </div>
  );
};
Demonstrativofiltro.propTypes = {
  pesquisar: PropTypes.func.isRequired,
};

export default Demonstrativofiltro;