import { useState } from 'react';
import { Card, CardBody, CardTitle, Button } from 'reactstrap';
import Relatoriopoxfaturado from '../../components/formulario/relatorio/Relatoriopoxfaturado';
import Relatoriototalacionamento from '../../components/formulario/relatorio/Relatoriototalacionamento';
import RelatorioCursoTreinamento from '../../components/formulario/relatorio/RelatorioCursoTreinamento';
import Relatoriofechamento from '../../components/formulario/relatorio/Relatoriofechamento';
import Relatoriodespesa from '../../components/formulario/relatorio/Relatoriodespesa';

export default function Relatoriomenu() {
  const [telarelatorio, settelarelatorio] = useState('');
  const [telarelatoriodespesa, settelarelatoriodespesa] = useState('');
  const [telarelatorioacionamento, settelarelatorioacionamento] = useState('');
  const [telarelatoriofechamento, settelarelatoriofechamento] = useState('');
  const [telarelatorioCursoTreinamento, settelarelatorioCursoTreinamento] = useState('');

  /*  function relpoxfat() {
      settelarelatorio(true);
    } */

  function despesas() {
    settelarelatoriodespesa(true);
  }

  function relacionamento() {
    settelarelatorioacionamento(true);
  }
  function relfechamento() {
    settelarelatoriofechamento(true);
  }
  function relCursoTreinamento() {
    settelarelatorioCursoTreinamento(true);
  }

  return (
    <div className="col-sm-12">
      <Card>
        <CardBody className="bg-light">
          <CardTitle tag="h4" className="mb-0">
            Relatórios Ericsson
          </CardTitle>
        </CardBody>
        <CardBody style={{ backgroundColor: 'white' }}>
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

          {telarelatorioacionamento ? (
            <>
              <Relatoriototalacionamento show={telarelatorioacionamento} setshow={settelarelatorioacionamento} />
            </>
          ) : null}
          {telarelatoriofechamento ? (
            <>
              <Relatoriofechamento show={telarelatoriofechamento} setshow={settelarelatoriofechamento} />
            </>
          ) : null}
          {telarelatorioCursoTreinamento ? (
            <>
              <RelatorioCursoTreinamento show={telarelatorioCursoTreinamento} setshow={settelarelatorioCursoTreinamento} />
            </>
          ) : null}
          {/* <Button color="link" onClick={() => relpoxfat()}>
            Valor Po x Valor Faturado
          </Button>
          <br></br>*/}
          <Button color="link" onClick={() => despesas()}>
            Relatorio de Despesas
          </Button>
          <br></br>
          <Button color="link" onClick={() => relacionamento()}>
            Total de Acionamentos
          </Button>
          <br></br>
          <Button color="link" onClick={() => relfechamento()}>
            Historico de Fechamento
          </Button>
          <br></br>
          <Button color="link" onClick={() => relCursoTreinamento()}>
            Curso / Treinamento
          </Button>
          {/* <br></br>
          <Button color="link" onClick={() => relCursoTreinamento()}>
            Despesas
          </Button>*/}
        </CardBody>
      </Card>
    </div>
  );
}