import { useState } from 'react';
import { Card, CardBody, CardTitle, Button } from 'reactstrap';
import Folhapagamento from '../../components/formulario/rh/Folhapagamento';
import Multa from '../../components/formulario/rh/Multa';
import Ticket from '../../components/formulario/rh/Ticket';
import Valetransporte from '../../components/formulario/rh/Valetransporte';
import Convenio from '../../components/formulario/rh/Convenio';

export default function Rh() {
  const [telamulta, settelamulta] = useState('');
  const [telafolhapagamento, settelafolhapagamento] = useState('');
  const [telaconvenio, settelaconvenio] = useState('');
  const [telaticket, settelaticket] = useState('');
  const [telavaletransporte, settelavaletransporte] = useState('');

  /*  function relpoxfat() {
      settelarelatorio(true);
    } */

  function folhapagamento() {
    settelafolhapagamento(true);
  }

  function multa() {
    settelamulta(true);
  }
  function convenio() {
    settelaconvenio(true);
  }
  function ticket() {
    settelaticket(true);
  }
  function valetransporte() {
    settelavaletransporte(true);
  }



  return (
    <div className="col-sm-12">
      <Card>
        <CardBody className="bg-light">
          <CardTitle tag="h4" className="mb-0">
            Recursos Humanos
          </CardTitle>
        </CardBody>
        <CardBody style={{ backgroundColor: 'white' }}>
          {telafolhapagamento ? (
            <>
              <Folhapagamento show={telafolhapagamento} setshow={settelafolhapagamento} />
            </>
          ) : null}

          {telamulta ? (
            <>
              <Multa show={telamulta} setshow={settelamulta} />
            </>
          ) : null}
          {telaconvenio ? (
            <>
              <Convenio show={telaconvenio} setshow={settelaconvenio} />
            </>
          ) : null}
          {telaticket ? (
            <>
              <Ticket show={telaticket} setshow={settelaticket} />
            </>
          ) : null}
          {telavaletransporte ? (
            <>
              <Valetransporte show={telavaletransporte} setshow={settelavaletransporte} />
            </>
          ) : null}


          <Button color="link" onClick={() => folhapagamento()}>
            Folha de Pagamento
          </Button>
          <br></br>
          <Button color="link" onClick={() => multa()}>
            Multas
          </Button>
          <br></br>
          <Button color="link" onClick={() => ticket()}>
            Ticket Restaurante
          </Button>
          <br></br>
          <Button color="link" onClick={() => valetransporte()}>
            Vale Transporte
          </Button>
          <br></br>
          <Button color="link" onClick={() => convenio()}>
            Convenio
          </Button>
          <br></br>
          <Button color="link" >
            Ferias PJ
          </Button>
        </CardBody>
      </Card>
    </div>
  );
}