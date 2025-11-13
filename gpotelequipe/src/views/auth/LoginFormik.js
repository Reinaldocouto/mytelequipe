import { useEffect, useState } from 'react';
import {
  Container,
  Row,
  Col,
  Card,
  CardBody,
  FormGroup,
  Label,
  Input,
  Button,
  CardFooter,
} from 'reactstrap';
import { Link, useNavigate } from 'react-router-dom';
import AuthLogo from '../../layouts/logo/AuthLogo';
import { ReactComponent as LeftBg } from '../../assets/images/bg/login-bgleft.svg';
import { ReactComponent as RightBg } from '../../assets/images/bg/login-bg-right.svg';
import api from '../../services/api';
import SaltPassword from '../../services/md5';
import Loader from '../../layouts/loader/Loader';

const LoginFormik = () => {
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [sucesso, setSucesso] = useState('');
  const [loading, setloading] = useState(false);
  useEffect(() => {
    localStorage.clear();
  });

  const [emailError, setEmailError] = useState('');
  const validateEmail = (e) => {
    if (e === '') {
      setEmailError('E-mail obrigatório');
    }
    if (/\S+@\S+\.\S+/.test(e)) {
      setEmailError('');
      setEmail(e);
    } else {
      setEmailError('Entre com um e-mail valido');
    }
  };

  function isValidPassword(passwordValue) {
    if (passwordValue === '') {
      return false;
    }

    return true;
  }
  const [passwordError, setPasswordError] = useState('');
  const validatePassword = (e) => {
    if (isValidPassword(e)) {
      setPasswordError('');
      setSenha(e);
    } else {
      setPasswordError('Senha obrigatória');
    }
  };
  const navigate = useNavigate();
  const listacontroleacesso = async () => {
    //Parametros
    const params = {
      idcliente: localStorage.getItem('sessionCodidcliente'),
      idusuario: localStorage.getItem('sessionId'),
      idloja: localStorage.getItem('sessionloja'),
      idcontroleacessobusca: localStorage.getItem('sessionId'),
      deletado: 0,
    };
    try {
      if (localStorage.getItem('permission') == null) {
        await api.get('v1/cadusuariosistemaid', { params }).then(async (response) => {
          console.log('entrou');
          await localStorage.setItem('permission', JSON.stringify(response.data));
        });
      }
    } catch (e) {
      console.log(e);
    }
  };
  const setSession = (response) => {
    const now = new Date();
    const daysUntilSunday = 7 - now.getDay();
    now.setDate(now.getDate() + daysUntilSunday);
    now.setHours(23, 59, 59, 999);

    localStorage.setItem('sessionExpiration', now.getTime());
    localStorage.setItem('sessionToken', response.data.token);
    localStorage.setItem('sessionId', response.data.idusuario);
    localStorage.setItem('sessionEmail', email);
    localStorage.setItem('sessionloja', response.data.idloja);
    localStorage.setItem('sessionCodidcliente', response.data.idcliente);
    localStorage.setItem('sessionNome', response.data.nome);
    localStorage.setItem('sessionplano', response.data.idplano);
    localStorage.setItem('isLogged', JSON.stringify(true));
  };

  function ProcessaLogin(e) {
    e.preventDefault();
    setSucesso('');
    setloading(true);
    api
      .post('v1/usuarios/login', {
        email,
        senha: SaltPassword(senha),
      })
      .then(async (response) => {
        setSession(response);
        await listacontroleacesso();

        setSucesso('S');

        setloading(false);
        navigate('/dashboard');
      })
      .catch((err) => {
        console.log(err);
        setloading(false);
        setSucesso('N');
      });
  }

  return loading ? (
    <Loader />
  ) : (
    <div className="loginBox">
      <LeftBg className="position-absolute left bottom-0" />
      <RightBg className="position-absolute end-0 top" />
      <Container fluid className="h-100">
        <Row className="justify-content-center align-items-center h-100">
          <Col lg="12" className="loginContainer">
            <AuthLogo />
            <Card>
              <CardBody className="p-4 m-1">
                <h4 className="mb-0 fw-bold">Login</h4>
                <br />
                <FormGroup>
                  <Label>E-mail</Label>
                  <Input
                    type="text"
                    style={{ textTransform: 'lowercase' }}
                    onChange={(e) => validateEmail(e.target.value)}
                    placeholder="Digite seu e-mail"
                  />
                  <Label style={{ color: 'red' }}>{emailError}</Label>
                </FormGroup>
                <FormGroup>
                  <Label>Senha</Label>
                  <Input
                    type="password"
                    onChange={(e) => validatePassword(e.target.value)}
                    placeholder="Digite sua senha"
                  />
                  <Label style={{ color: 'red' }}>{passwordError}</Label>
                  <Link
                    style={{ color: '#7B176E' }}
                    className="ms-auto text-decoration-none text-center"
                    to="/recuperar-senha"
                  >
                    <medium>Esqueci minha senha?</medium>
                  </Link>
                </FormGroup>
                <FormGroup className="form-check d-flex justify-content-center text-center" inline>
                  <Button type="submit" color="primary" className="me-2" onClick={ProcessaLogin}>
                    Entrar
                  </Button>
                </FormGroup>
              </CardBody>
              <CardFooter>
                {sucesso === 'N' ? (
                  <div className="alert alert-danger mt-2" role="alert">
                    E-mail ou senha inválida
                  </div>
                ) : null}
                <div className="text-center mt-2" style={{ fontSize: '12px', color: '#666' }}>
                  Versão 0.0.3
                </div>
              </CardFooter>
            </Card>
          </Col>
        </Row>
      </Container>
    </div>
  );
};

export default LoginFormik;
