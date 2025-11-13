import { useState } from 'react';
import { Card, CardBody, Button, Row, Col } from 'reactstrap';
//import IndicadorAlerta from '../../components/dashboard/Indicadores/AlertaIndicador';
import BreadCrumbs from '../../layouts/breadcrumbs/BreadCrumbs';
import ComponentCard from '../../components/ComponentCard';
import Ericssonadicional from '../../components/formulario/projeto/Ericssonadicional';
import Ericssoncontrolelpu from '../../components/formulario/projeto/Ericssoncontrolelpu';
import Ericssonfechamento from '../../components/formulario/projeto/Ericssonfechamento';
import Relatoriopoxfaturado from '../../components/formulario/relatorio/Relatoriopoxfaturado';
import Relatoriototalacionamento from '../../components/formulario/relatorio/Relatoriototalacionamento';
import Relatoriofechamento from '../../components/formulario/relatorio/Relatoriofechamento';
import Relatoriodespesa from '../../components/formulario/relatorio/Relatoriodespesa';
import Zteacionamento from '../../components/formulario/projeto/Zteacionamento';

export default function Comercial() {

    const [teladocumentos, setteladocumentos] = useState('');
    const [telaadicional, settelaadicional] = useState('');
    const [telalpu, settelalpu] = useState('');
    const [telafechamento, settelafechamento] = useState('');
    const [telarelatorio, settelarelatorio] = useState('');
    const [telarelatoriodespesa, settelarelatoriodespesa] = useState('');
    const [telarelatorioacionamento, settelarelatorioacionamento] = useState('');
    const [telarelatoriofechamento, settelarelatoriofechamento] = useState('');

    function documentos() {
        setteladocumentos(true);
    }

    function adicional() {
        settelaadicional(true);
    }

    function despesas() {
        settelarelatoriodespesa(true);
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
                teladocumentos ? (
                    <>
                      <Zteacionamento show={teladocumentos} setshow={setteladocumentos} />
                    </>
                ) : null
            }

            {
                telaadicional ? (
                    <>
                        <Ericssonadicional show={telaadicional} setshow={settelaadicional} />
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
                        <Button color="link" onClick={() => documentos()}>
                            Cadastro de documentação
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => adicional()}>
                            Cadastro LPU
                        </Button>
                        <br></br>
                    </CardBody>
                </ComponentCard>
                <ComponentCard title='Relatórios'>
                    <CardBody style={{ backgroundColor: 'white' }}>
                        <Button color="link" onClick={() => despesas()}>
                            Despesas
                        </Button>
                        <br></br>
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