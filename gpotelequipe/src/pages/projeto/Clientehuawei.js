import { useState } from 'react';
import { Card, CardBody, Button, Row, Col } from 'reactstrap';
//import IndicadorAlerta from '../../components/dashboard/Indicadores/AlertaIndicador';
import BreadCrumbs from '../../layouts/breadcrumbs/BreadCrumbs';
import ComponentCard from '../../components/ComponentCard';
import Ericssoncontrolelpu from '../../components/formulario/projeto/Ericssoncontrolelpu';
import Ericssonfechamento from '../../components/formulario/projeto/Ericssonfechamento';
import Relatoriopoxfaturado from '../../components/formulario/relatorio/Relatoriopoxfaturado';
import Relatoriototalacionamento from '../../components/formulario/relatorio/Relatoriototalacionamento';
import Relatoriofechamento from '../../components/formulario/relatorio/Relatoriofechamento';
import Relatoriodespesa from '../../components/formulario/relatorio/Relatoriodespesa';
import Huaweiacionamento from '../../components/formulario/projeto/Huaweiacionamento';

export default function Clientehuawei() {

    const [telaacionamento, settelaacionamento] = useState('');
    const [telalpu, settelalpu] = useState('');
    const [telafechamento, settelafechamento] = useState('');
    const [telarelatorio, settelarelatorio] = useState('');
    const [telarelatoriodespesa, settelarelatoriodespesa] = useState('');
    const [telarelatorioacionamento, settelarelatorioacionamento] = useState('');
    const [telarelatoriofechamento, settelarelatoriofechamento] = useState('');

    function acionamento() {
        settelaacionamento(true);
    }



    function fechamento() {
        settelafechamento(true);
    }

    function relacionamento() {
        settelarelatorioacionamento(true);
    }
    function relfechamento() {
        settelarelatoriofechamento(true);
    }


    return (

        <div className="col-sm-12">

            {
                telaacionamento ? (
                    <>
                        <Huaweiacionamento show={telaacionamento} setshow={settelaacionamento} />
                    </>
                ) : null
            }

            {
                telalpu ? (
                    <>
                        <Ericssoncontrolelpu show={telalpu} setshow={settelalpu} />
                    </>
                ) : null
            }

            {
                telafechamento ? (
                    <>
                        <Ericssonfechamento show={telafechamento} setshow={settelafechamento} />
                    </>
                ) : null
            }

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


            <Card>
                <CardBody style={{ backgroundColor: 'white' }}>
                    <BreadCrumbs />
                    <Row>
                        <Col lg="12">
                          {/*  <IndicadorAlerta /> */}
                        </Col>
                    </Row>
                </CardBody>
                <ComponentCard title='Opções'>
                    <CardBody style={{ backgroundColor: 'white' }}>
                        <Button color="link" onClick={() => acionamento()}>
                            Acionamento
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => fechamento()}>
                            Fechamento
                        </Button>

                    </CardBody>
                </ComponentCard>
                <ComponentCard title='Relatórios'>
                    <CardBody style={{ backgroundColor: 'white' }}>
                        <Button color="link" onClick={() => relacionamento()}>
                            Total de Acionamentos
                        </Button>
                        <br></br>
                        <Button color="link" >
                            Previsão de Fechamento
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => relfechamento()}>
                            Historico de Fechamento
                        </Button>
                    </CardBody>
                </ComponentCard>

            </Card>
        </div>
    );
}