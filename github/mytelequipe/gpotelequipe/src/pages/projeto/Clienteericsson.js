import { useState, useEffect } from 'react';
import { Card, CardBody, Button } from 'reactstrap';
import BreadCrumbs from '../../layouts/breadcrumbs/BreadCrumbs';
import ComponentCard from '../../components/ComponentCard';
import Ericssonacionamento from '../../components/formulario/projeto/Ericssonacionamento';
import Ericssonadicional from '../../components/formulario/projeto/Ericssonadicional';
import Ericssoncontrolelpu from '../../components/formulario/projeto/Ericssoncontrolelpu';
import Ericssonfechamento from '../../components/formulario/projeto/Ericssonfechamento';
import Relatoriopoxfaturado from '../../components/formulario/relatorio/Relatoriopoxfaturado';
import Relatoriototalacionamento from '../../components/formulario/relatorio/Relatoriototalacionamento';
import Relatoriofechamento from '../../components/formulario/relatorio/Relatoriofechamento';
import Relatoriodespesa from '../../components/formulario/relatorio/Relatoriodespesa';
import Demonstrativoview from '../../components/formulario/demonstrativo/Demonstrativoview';
import api from '../../services/api';




export default function Clienteericsson() {


    const [telaacionamento, settelaacionamento] = useState('');
    const [telaadicional, settelaadicional] = useState('');
    const [telalpu, settelalpu] = useState('');
    const [telafechamento, settelafechamento] = useState('');
    const [telarelatorio, settelarelatorio] = useState('');
    const [telarelatoriodespesa, settelarelatoriodespesa] = useState('');
    const [telarelatorioacionamento, settelarelatorioacionamento] = useState('');
    const [telarelatoriofechamento, settelarelatoriofechamento] = useState('');
    const [telademonstrativo, settelademonstrativo] = useState('');
    const [demanda, setdemanda] = useState('');
    const [entrega, setentrega] = useState('');
    const [entregaandamento, setentregaandamento] = useState('');
    const [instalacao, setinstalacao] = useState('');
    const [instalacaoandamento, setinstalacaoandamento] = useState('');
    const [valinstalacao, setvalinstalacao] = useState('');
    const [valinstalacaoandamento, setvalinstalacaoandamento] = useState('');
    const [integracao, setintegracao] = useState('');
    const [integracaoandamento, setintegracaoandamento] = useState('');
    const [documentacao, setdocumentacao] = useState('');
    const [documentacaoandamento, setdocumentacaoandamento] = useState('');
    const [aceito, setaceito] = useState('');
    const [naoaceito, setnaoaceito] = useState('');

    function acionamentoericsson() {
        settelaacionamento(true);
    }

    function adicionalericsson() {
        settelaadicional(true);
    }

    function lpuericsson() {
        settelalpu(true);
    }

    function fechamentoericsson() {
        settelafechamento(true);
    }

    function despesas() {
        settelarelatoriodespesa(true);
    }

    function demonstrativo() {
        settelademonstrativo(true);
    }

    function relacionamento() {
        settelarelatorioacionamento(true);
    }
    function relfechamento() {
        settelarelatoriofechamento(true);
    }


    const cardStyle = {
        backgroundColor: '#f5f5f5',
        padding: '20px',
        borderRadius: '15px',
        boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        width: '100%',
        height: '150px',
        transition: 'transform 0.2s ease-in-out',
    };
    const titleStyle = {
        fontSize: '16px',
        fontWeight: 'bold',
        color: '#333',
        marginBottom: '10px',
        alignItems: 'center',
    };

    const subtitleStyle = {
        fontSize: '14px',
        color: '#333',
        marginBottom: '1px',
        alignItems: 'center',
    };

    const numberStyle = {
        fontSize: '32px',
        fontWeight: 'bold',
        color: '#99abb4',
    };

    const handleMouseEnter = (e) => {
        e.currentTarget.style.transform = 'scale(1.05)';
    };

    const handleMouseLeave = (e) => {
        e.currentTarget.style.transform = 'scale(1)';
    };



    const painelcontrole = async () => {
        try {
            const response = await api.get('v1/painelcontrole');
            const { data } = response;
            setdemanda(data.demanda);
            setentrega(data.entrega);
            setentregaandamento(data.entregaandamento);
            setinstalacao(data.instalacao);
            setinstalacaoandamento(data.instalacaoandamento);
            setintegracao(data.integracao);
            setintegracaoandamento(data.integracaoandamento);
            setvalinstalacao(data.valinstalacao);
            setvalinstalacaoandamento(data.valinstalacaoandamento);
            setdocumentacao(data.documentacao);
            setdocumentacaoandamento(data.documentacaoandamento);
            setaceito(data.aceito);
            setnaoaceito(data.naoaceito);

        } catch (error) {
            console.error('Erro ao obter valor de recebimento:', error.message);
        } finally {
            // setloading(false);
        }
    };
    const iniciatabelas = async () => {
        await Promise.all([
            painelcontrole()
        ]);
    };

    useEffect(() => {
        iniciatabelas();
    }, []);

    return (



        <div className="col-sm-12">

            {
                telaacionamento ? (
                    <>
                        <Ericssonacionamento show={telaacionamento} setshow={settelaacionamento} />
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

            {telademonstrativo ? (
                <>
                    <Demonstrativoview show={telademonstrativo} setshow={settelademonstrativo} />
                </>
            ) : null}


            <Card>

                <CardBody style={{ backgroundColor: 'white' }}>

                    <BreadCrumbs />
                    <div className="row g-3">
                        <div className="col-sm-3">
                            <div
                                style={cardStyle}
                                onMouseEnter={handleMouseEnter}
                                onMouseLeave={handleMouseLeave}
                            >
                                {/* Título no topo */}
                                <p style={titleStyle}>DEMANDA</p>
                                <div style={subtitleStyle}>--</div>


                                {/* Container para os números com espaçamento */}
                                <div style={{ display: 'flex', justifyContent: 'center', gap: '60px' }}>
                                    <div style={{ textAlign: 'center' }}>
                                        <p style={numberStyle}>{demanda}</p>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <div className="col-sm-3">
                            <div
                                style={cardStyle}
                                onMouseEnter={handleMouseEnter}
                                onMouseLeave={handleMouseLeave}
                            >
                                {/* Título no topo */}
                                <p style={titleStyle}>ENTREGA</p>

                                {/* Container para os números com espaçamento */}
                                <div style={{ display: 'flex', justifyContent: 'center', gap: '60px' }}>
                                    <div style={{ textAlign: 'center' }}>
                                        <div style={subtitleStyle}>Concluido</div>
                                        <p style={numberStyle}>{entrega}</p>
                                    </div>
                                    <div style={{ textAlign: 'center' }}>
                                        <div style={subtitleStyle}>Andamento</div>
                                        <p style={numberStyle}>{entregaandamento}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="col-sm-3">
                            <div
                                style={cardStyle}
                                onMouseEnter={handleMouseEnter}
                                onMouseLeave={handleMouseLeave}
                            >
                                {/* Título no topo */}
                                <p style={titleStyle}>INSTALAÇÃO</p>

                                {/* Container para os números com espaçamento */}
                                <div style={{ display: 'flex', justifyContent: 'center', gap: '60px' }}>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Concluido</div>
                                        <p style={numberStyle}>{instalacao}</p>
                                    </div>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Andamento</div>
                                        <p style={numberStyle}>{instalacaoandamento}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="col-sm-3">
                            <div
                                style={cardStyle}
                                onMouseEnter={handleMouseEnter}
                                onMouseLeave={handleMouseLeave}
                            >
                                {/* Título no topo */}
                                <p style={titleStyle}>VAL. INSTALAÇÃO</p>

                                {/* Container para os números com espaçamento */}
                                <div style={{ display: 'flex', justifyContent: 'center', gap: '60px' }}>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Concluido</div>
                                        <p style={numberStyle}>{valinstalacao}</p>
                                    </div>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Andamento</div>
                                        <p style={numberStyle}>{valinstalacaoandamento}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="col-sm-3">
                            <div
                                style={cardStyle}
                                onMouseEnter={handleMouseEnter}
                                onMouseLeave={handleMouseLeave}
                            >
                                {/* Título no topo */}
                                <p style={titleStyle}>INTEGRAÇÃO</p>

                                {/* Container para os números com espaçamento */}
                                <div style={{ display: 'flex', justifyContent: 'center', gap: '60px' }}>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Concluido</div>
                                        <p style={numberStyle}>{integracao}</p>
                                    </div>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Andamento</div>
                                        <p style={numberStyle}>{integracaoandamento}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="col-sm-3">
                            <div
                                style={cardStyle}
                                onMouseEnter={handleMouseEnter}
                                onMouseLeave={handleMouseLeave}
                            >
                                {/* Título no topo */}
                                <p style={titleStyle}>DOCUMENTAÇÃO</p>

                                {/* Container para os números com espaçamento */}
                                <div style={{ display: 'flex', justifyContent: 'center', gap: '60px' }}>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Concluido</div>
                                        <p style={numberStyle}>{documentacao}</p>
                                    </div>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Andamento</div>
                                        <p style={numberStyle}>{documentacaoandamento}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="col-sm-3">
                            <div
                                style={cardStyle}
                                onMouseEnter={handleMouseEnter}
                                onMouseLeave={handleMouseLeave}
                            >
                                {/* Título no topo */}
                                <p style={titleStyle}>ACEITOS</p>

                                {/* Container para os números com espaçamento */}
                                <div style={{ display: 'flex', justifyContent: 'center', gap: '60px' }}>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Concluido</div>
                                        <p style={numberStyle}>{aceito}</p>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div className="col-sm-3">
                            <div
                                style={cardStyle}
                                onMouseEnter={handleMouseEnter}
                                onMouseLeave={handleMouseLeave}
                            >
                                {/* Título no topo */}
                                <p style={titleStyle}>NÃO ACEITOS</p>

                                {/* Container para os números com espaçamento */}
                                <div style={{ display: 'flex', justifyContent: 'center', gap: '60px' }}>
                                    <div style={{ textAlign: 'center' }}>
                                    <div style={subtitleStyle}>Andamento</div>
                                        <p style={numberStyle}>{naoaceito}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br></br>

                </CardBody>
                <ComponentCard title='Opções'>
                    <CardBody style={{ backgroundColor: 'white' }}>
                        <Button color="link" onClick={() => acionamentoericsson()}>
                            Acionamento
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => adicionalericsson()}>
                            Adicional
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => lpuericsson()}>
                            LPU
                        </Button>
                        <br></br>
                        <Button color="link" onClick={() => fechamentoericsson()}>
                            Fechamento
                        </Button>

                    </CardBody>
                </ComponentCard>
                <ComponentCard title='Relatórios'>
                    <CardBody style={{ backgroundColor: 'white' }}>
                        <Button color="link" onClick={() => demonstrativo()}>
                            Demonstrativo
                        </Button>
                        <br></br>
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
        </div >
    );
}