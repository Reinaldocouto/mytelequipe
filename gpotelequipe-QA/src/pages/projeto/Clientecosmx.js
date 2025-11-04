import { useState, useEffect } from 'react';
import { Card, CardBody, Button, Row, Col } from 'reactstrap';
import Chart from 'react-apexcharts';
import BreadCrumbs from '../../layouts/breadcrumbs/BreadCrumbs';
import ComponentCard from '../../components/ComponentCard';
import Cosmxacionamento from '../../components/formulario/projeto/Cosmxacionamento';
import Ericssonadicional from '../../components/formulario/projeto/Ericssonadicional';
import Ericssoncontrolelpu from '../../components/formulario/projeto/Ericssoncontrolelpu';
import Relatoriopoxfaturado from '../../components/formulario/relatorio/Relatoriopoxfaturado';
import Relatoriodespesa from '../../components/formulario/relatorio/Relatoriodespesa';
import Cosmxfechamento from '../../components/formulario/projeto/Cosmxfechamento';
import api from '../../services/api';
import Loader from '../../layouts/loader/Loader';
import Relatoriocosmxconsolidado from '../../components/formulario/relatorio/Relatoriocosmxconsolidado';
import Relatoriocosmxhistorico from '../../components/formulario/relatorio/Relatoriocosmxhistorico';
import Relatoriocosmxcontrole from '../../components/formulario/relatorio/Relatoriocosmxcontrole';

export default function Clientecosmx() {

    const [telaacionamento, settelaacionamento] = useState('');
    const [telaadicional, settelaadicional] = useState('');
    const [telalpu, settelalpu] = useState('');
    const [telafechamento, settelafechamento] = useState('');
    const [telarelatorio, settelarelatorio] = useState('');
    const [telarelatoriodespesa, settelarelatoriodespesa] = useState('');
    const [telarelatoriocontrole, settelarelatoriocontrole] = useState('');
    const [telarelatorioconsolidado, settelarelatorioconsolidado] = useState('');
    const [telahistorico, settelahistorico] = useState('');
    const [planejado, setplanejado] = useState([]);
    const [compo, setcompo] = useState([]);
    const [sempo, setsempo] = useState([]);
    const [region, setregion] = useState([]);
    const [loading, setloading] = useState('');
    const [dadostab, setdadostab] = useState([]);

    function acionamento() {
        settelaacionamento(true);
    }

    function lpu() {
        settelalpu(true);
    }

    function fechamento() {
        settelafechamento(true);
    }

    function relcontrole() {
        settelarelatoriocontrole(true);
    }
    function relconsolidado() {
        settelarelatorioconsolidado(true);
    }
    function relhistorico() {
        settelahistorico(true);
    }


    const demonstrativocosmx = async () => {
        try {
            setloading(true);
            const response = await api.get('v1/projetocosmx/demonstrativo');
            if (response.status === 200) {
                const dados = response.data;
                setdadostab(response.data)
                setplanejado(dados.map(item => item.planejado))
                setcompo(dados.map(item => item.compo))
                setsempo(dados.map(item => item.sempo))
                setregion(dados.map(item => item.regiao))
            }
        } catch (err) {
            console.log(err.message);
        } finally {
            setloading(false);
        }
    };
    const seriescolumn = [
        {

            name: 'Planejados',
            data: planejado,
        },
        {
            name: 'Com Po',
            data: compo,
        },
        {
            name: 'Sem PO',
            data: sempo,
        },
    ];

    const optionscolumn = {
        colors: ['#745af2', '#B6FFA1', '#4fc3f7'],
        chart: {
            fontFamily: "'Rubik', sans-serif",
        },
        plotOptions: {
            bar: {
                horizontal: false,
                endingShape: 'rounded',
                columnWidth: '55%',
            },
        },
        dataLabels: {
            enabled: false,
        },
        stroke: {
            show: true,
            width: 2,
            colors: ['transparent'],
        },
        xaxis: {
            categories: region,
            labels: {
                style: {
                    cssClass: 'grey--text lighten-2--text fill-color',
                },
            },
        },
        yaxis: {
            title: {
                text: 'Sites',
                color: '#8898aa',
            },
            labels: {
                style: {
                    cssClass: 'grey--text lighten-2--text fill-color',
                },
            },
        },
        fill: {
            opacity: 1,
        },
        tooltip: {
            theme: 'dark',
            y: {
                formatter(val) {
                    return `${val} Sites`;
                },
            },
        },
        grid: {
            borderColor: 'rgba(0,0,0,0.1)',
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
    };
    const iniciatabelas = () => {
        demonstrativocosmx();
    };

    useEffect(() => {
        iniciatabelas();
    }, []);
    return (

        <div className="col-sm-12">

            {
                telaacionamento ? (
                    <>
                        <Cosmxacionamento show={telaacionamento} setshow={settelaacionamento} />

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
                        <Cosmxfechamento show={telafechamento} setshow={settelafechamento} />
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

            {telarelatoriocontrole ? (
                <>
                    <Relatoriocosmxcontrole show={telarelatoriocontrole} setshow={settelarelatoriocontrole} />
                </>
            ) : null}
            {telarelatorioconsolidado ? (
                <>
                    <Relatoriocosmxconsolidado show={telarelatorioconsolidado} setshow={settelarelatorioconsolidado} />
                </>
            ) : null}

            {telahistorico ? (
                <>
                    <Relatoriocosmxhistorico show={telahistorico} setshow={settelahistorico} />
                </>
            ) : null}


            <Card>

                <CardBody style={{ backgroundColor: 'white' }}>

                    <BreadCrumbs />
                    {loading ? <Loader /> :
                        <>
                            <Row>
                                <Col lg="12" >
                                    <ComponentCard title="Evolução COSMX" >
                                        <Chart options={optionscolumn} series={seriescolumn} type="bar" height="280" style={{ backgroundColor: 'white' }} />
                                    </ComponentCard>
                                </Col>
                            </Row>
                            <br></br>
                            <Row>
                                <Col lg="4" >
                                    <table style={{ width: '100%', borderCollapse: 'collapse', backgroundColor: 'white' }}>
                                        <thead>
                                            <tr>
                                                <th style={{ textAlign: 'center', border: '1px solid black', padding: '4px', backgroundColor: 'white' }}>REGIÕES</th>
                                                <th style={{ textAlign: 'center', border: '1px solid black', padding: '4px', backgroundColor: 'white' }}>PLANEJADOS</th>
                                            </tr>
                                        </thead>
                                        <tbody >
                                            {dadostab.map((item) => (
                                                <tr key={item.id}>
                                                    <td style={{ textAlign: 'center', border: '1px solid black', padding: '4px' }}>{item.regiao}</td>
                                                    <td style={{ textAlign: 'center', border: '1px solid black', padding: '4px' }}>{item.planejado}</td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                </Col>

                            </Row>
                        </>
                    }
                </CardBody>
                <ComponentCard title='Opções'>
                    <CardBody style={{ backgroundColor: 'white' }}>
                        <Button color="link" onClick={() => acionamento()}>
                            Acionamento
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => lpu()}>
                            LPU
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => fechamento()}>
                            Fechamento
                        </Button>

                    </CardBody>
                </ComponentCard>
                <ComponentCard title='Relatórios'>
                    <CardBody style={{ backgroundColor: 'white' }}>
                        <Button color="link" onClick={() => relcontrole()}>
                            Obras Cosmx Controle
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => relhistorico()}>
                            Historico Pagamento Cosmx
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => relconsolidado()}>
                            Consolidado Pagamento Cosmx
                        </Button>
                    </CardBody>
                </ComponentCard>

            </Card>
        </div>
    );
}