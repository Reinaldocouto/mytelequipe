import { useState } from 'react';
import { Card, CardBody, Button, Row, Col } from 'reactstrap';
//import IndicadorAlerta from '../../components/dashboard/Indicadores/AlertaIndicador';
import BreadCrumbs from '../../layouts/breadcrumbs/BreadCrumbs';
import ComponentCard from '../../components/ComponentCard';
import Relatoriopoxfaturado from '../../components/formulario/relatorio/Relatoriopoxfaturado';
import Relatoriofechamento from '../../components/formulario/relatorio/Relatoriofechamento';
import Relatoriodespesa from '../../components/formulario/relatorio/Relatoriodespesa';
import Zteacionamento from '../../components/formulario/projeto/Zteacionamento';
import Ztefechamento from '../../components/formulario/projeto/Ztefechamento';
import Ztedocumentacao from '../../components/formulario/projeto/Ztedocumentacao';
import Rolloutzte from '../rollout/Rolloutzte';
import Relatoriototalacionamentozte from '../../components/formulario/relatorio/Relatoriototalacionamentozte';
import Ztecontrolelpu from '../../components/formulario/projeto/Ztecontrolelpu';

export default function Clientezte() {
  const [telaacionamento, settelaacionamento] = useState('');
  const [telalpu, settelalpu] = useState('');
  const [telarollout, settelarollout] = useState('');
  const [telafechamento, settelafechamento] = useState('');
  const [telarelatorio, settelarelatorio] = useState('');
  const [telarelatoriodespesa, settelarelatoriodespesa] = useState('');
  const [telarelatoriofechamento, settelarelatoriofechamento] = useState('');
  const [teladocumento, setteladocumento] = useState('');
  const [telatotalacionamento, settelatotalacionamento] = useState('');

  function acionamento() {
    settelaacionamento(true);
  }

  function lpu() {
    settelalpu(true);
  }

  function totalacionamento() {
    settelatotalacionamento(true);
  }

  function rollout() {
    settelarollout(true);
  }

  function fechamento() {
    settelafechamento(true);
  }

  function documentacao() {
    setteladocumento(true);
  }

  return (
    <div className="col-sm-12">
      {telaacionamento ? (
        <>
          <Zteacionamento show={telaacionamento} setshow={settelaacionamento} />
        </>
      ) : null}

      {telalpu ? (
        <>
          <Ztecontrolelpu show={telalpu} setshow={settelalpu} />
        </>
      ) : null}

      {telarollout ? (
        <>
          <Rolloutzte show={telarollout} setshow={settelarollout} />
        </>
      ) : null}

      {telafechamento ? (
        <>
          <Ztefechamento show={telafechamento} setshow={settelafechamento} />
        </>
      ) : null}

      {teladocumento ? (
        <>
          <Ztedocumentacao show={teladocumento} setshow={setteladocumento} />
        </>
      ) : null}

      {telarelatorio ? (
        <>
          <Relatoriopoxfaturado show={telarelatorio} setshow={settelarelatorio} />
        </>
      ) : null}
      {telarelatoriodespesa ? (
        <>
          <Relatoriodespesa show={telarelatoriodespesa} setshow={settelarelatoriodespesa} />
        </>
      ) : null}

      {telarelatoriofechamento ? (
        <>
          <Relatoriofechamento
            show={telarelatoriofechamento}
            setshow={settelarelatoriofechamento}
          />
        </>
      ) : null}

      {telatotalacionamento ? (
        <>
          <Relatoriototalacionamentozte
            show={telatotalacionamento}
            setshow={settelatotalacionamento}
          />
        </>
      ) : null}

      <Card>
        <CardBody style={{ backgroundColor: 'white' }}>
          <BreadCrumbs />
          <Row>
            <Col lg="12">{/*  <IndicadorAlerta /> */}</Col>
          </Row>
        </CardBody>
        <ComponentCard title="Opções">
          <CardBody style={{ backgroundColor: 'white' }}>
            <Button color="link" onClick={() => rollout()}>
              Rollout
            </Button>
            <br></br>
            <Button color="link" onClick={() => documentacao()}>
              Acesso
            </Button>
            <br></br>
            <Button color="link" onClick={() => acionamento()}>
              Acionamento
            </Button>
            <br></br>

            <Button color="link" onClick={() => documentacao()}>
              Documentação
            </Button>
            <br></br>
            <Button color="link" onClick={() => fechamento()}>
              Fechamento
            </Button>
            <br></br>
            <Button color="link" onClick={() => lpu()}>
              LPU
            </Button>
          </CardBody>
        </ComponentCard>
        <ComponentCard title="Relatórios">
          <CardBody style={{ backgroundColor: 'white' }}>
            {/*  <Button color="link" onClick={() => despesas()}>
                            Despesas
                        </Button>
                        <br></br> */}
            <Button color="link" onClick={() => totalacionamento()}>
              Total de Acionamentos
            </Button>
            <br></br>
            <Button color="link">Previsão de Fechamento</Button>
            <br></br>
            <Button color="link">Historico de Fechamento</Button>
          </CardBody>
        </ComponentCard>
      </Card>
    </div>
  );
}
