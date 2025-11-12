import { useState } from 'react';
import { Button, Label, FormGroup, Container, Row, Col, Card, CardBody } from 'reactstrap';
import { Link, useNavigate } from 'react-router-dom';
import { Formik, Field, Form, ErrorMessage } from 'formik';
import * as Yup from 'yup';
import AuthLogo from '../../layouts/logo/AuthLogo';
import { ReactComponent as LeftBg } from '../../assets/images/bg/login-bgleft.svg';
import { ReactComponent as RightBg } from '../../assets/images/bg/login-bg-right.svg';
import api from '../../services/api';
import SaltPassword from '../../services/md5';

const RecoverPassword = () => {
  const navigate = useNavigate();
  const [step, setStep] = useState(1); // Controle da etapa atual do formulário
  const [emailRecuperacao, setEmailRecuperacao] = useState('');
  const [tokenRecuperacao, setTokenRecuperacao] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const [successMessage, setSuccessMessage] = useState('');

  // Inicializações dos valores dos formulários
  const initialValues = {
    email: '',
    token: '',
    password: '',
    confirmpassword: '',
  };

  // Validações de cada formulário com Yup
  const validationSchema = {
    email: Yup.object().shape({
      email: Yup.string().email('Email está incorreto').required('Email é obrigatório'),
    }),
    token: Yup.object().shape({
      token: Yup.string().required('Token é obrigatório'),
    }),
    password: Yup.object().shape({
      password: Yup.string()
        .min(6, 'Senha deve ter pelo menos 6 caracteres')
        .required('Senha é obrigatória'),
      confirmpassword: Yup.string()
        .oneOf([Yup.ref('password'), null], 'Senhas devem ser iguais')
        .required('Confirmação de senha é obrigatória'),
    }),
  };

  // Função para avançar para a próxima etapa
  const nextStep = () => setStep((i) => i + 1);

  // Função para voltar para a etapa anterior
  const prevStep = () => {
    setStep((i) => i - 1);
    setSuccessMessage('');
    setErrorMessage('');
  };
  const onSubmitEnviarEmail = async (values, { setSubmitting }) => {
    try {
      const response = await api.post('v1/email/recuperarsenha', {
        email: values.email,
      });
      console.log(response);
      setEmailRecuperacao(values.email);
      nextStep();
      setSubmitting(false);
      setSuccessMessage('E-mail enviado com sucesso.');
    } catch (error) {
      console.error(error);
      setErrorMessage('Erro ao enviar o email. Tente novamente mais tarde.'); // Exemplo de mensagem de erro
      setSubmitting(false);
    }
  };

  const onSubmitValidarToken = async (values, { setSubmitting }) => {
    setSuccessMessage('');
    setErrorMessage('');
    try {
      const response = await api.post('v1/usuarios/validartoken', {
        email: emailRecuperacao,
        token: values.token,
      });
      console.log(response);
      setTokenRecuperacao(values.token);
      nextStep();
      setSubmitting(false);
    } catch (error) {
      console.error(error);
      setErrorMessage('Token inválido ou expirado.');
      setSubmitting(false);
    }
  };
  const onSubmitChangePassword = async (values, { setSubmitting }) => {
    setSuccessMessage('');
    setErrorMessage('');
    try {
      const response = await api.post('v1/usuarios/alterasenhaemail', {
        email: emailRecuperacao,
        token: tokenRecuperacao,
        senha: SaltPassword(values.password),
      });
      console.log(response);
      setSubmitting(false);
      navigate('/');
    } catch (error) {
      setErrorMessage('Erro ao alterar a senha. Tente novamente mais tarde.');
      setSubmitting(false);
    }
  };

  return (
    <div className="loginBox">
      <LeftBg className="position-absolute left bottom-0" />
      <RightBg className="position-absolute end-0 top" />
      <Container fluid className="h-100">
        <Row className="justify-content-center align-items-center h-100">
          <Col lg="12" className="loginContainer">
            <AuthLogo />
            <Card>
              {successMessage && (
                <div className="alert alert-success" role="alert">
                  {successMessage}
                </div>
              )}
              {errorMessage && (
                <div className="alert alert-danger" role="alert">
                  {errorMessage}
                </div>
              )}
              <CardBody className="p-4 m-1">
                {step === 1 && (
                  <Formik
                    initialValues={initialValues}
                    validationSchema={validationSchema.email}
                    onSubmit={onSubmitEnviarEmail}
                  >
                    {({ errors, touched }) => (
                      <Form className="mt-3">
                        <FormGroup>
                          <Label htmlFor="email">E-mail</Label>
                          <Field
                            name="email"
                            type="email"
                            className={`form-control${
                              errors.email && touched.email ? ' is-invalid' : ''
                            }`}
                          />
                          <ErrorMessage name="email" component="div" className="invalid-feedback" />
                        </FormGroup>
                        <FormGroup>
                          <Button type="submit" color="info" block>
                            Recuperar senha
                          </Button>
                        </FormGroup>
                        <Link
                          style={{ color: '#7B176E' }}
                          className="ms-auto text-decoration-none d-flex justify-content-center"
                          to="/"
                        >
                          <medium>Lembrei da minha senha</medium>
                        </Link>
                      </Form>
                    )}
                  </Formik>
                )}

                {step === 2 && emailRecuperacao !== '' && (
                  <Formik
                    initialValues={initialValues}
                    validationSchema={validationSchema.token}
                    onSubmit={onSubmitValidarToken}
                  >
                    {({ errors, touched }) => (
                      <Form className="mt-3">
                        <FormGroup>
                          <Label htmlFor="token">Token</Label>
                          <Field
                            name="token"
                            type="text"
                            className={`form-control${
                              errors.token && touched.token ? ' is-invalid' : ''
                            }`}
                          />
                          <ErrorMessage name="token" component="div" className="invalid-feedback" />
                        </FormGroup>
                        <FormGroup>
                          <Button type="submit" color="info" block>
                            Confirmar Token
                          </Button>
                        </FormGroup>
                        <Button type="button" color="secondary" block onClick={prevStep}>
                          Voltar
                        </Button>
                      </Form>
                    )}
                  </Formik>
                )}

                {step === 3 && (
                  <Formik
                    initialValues={initialValues}
                    validationSchema={validationSchema.password}
                    onSubmit={onSubmitChangePassword}
                  >
                    {({ errors, touched }) => (
                      <Form className="mt-3">
                        {emailRecuperacao !== '' && tokenRecuperacao !== '' && (
                          <>
                            <FormGroup>
                              <Label htmlFor="password">Nova senha</Label>
                              <Field
                                name="password"
                                type="password"
                                className={`form-control${
                                  errors.password && touched.password ? ' is-invalid' : ''
                                }`}
                              />
                              <ErrorMessage
                                name="password"
                                component="div"
                                className="invalid-feedback"
                              />
                            </FormGroup>
                            <FormGroup>
                              <Label htmlFor="confirmpassword">Confirmar Senha</Label>
                              <Field
                                name="confirmpassword"
                                type="password"
                                className={`form-control${
                                  errors.confirmpassword && touched.confirmpassword
                                    ? ' is-invalid'
                                    : ''
                                }`}
                              />
                              <ErrorMessage
                                name="confirmpassword"
                                component="div"
                                className="invalid-feedback"
                              />
                            </FormGroup>
                            <FormGroup>
                              <Button type="submit" color="info" block>
                                Salvar Senha
                              </Button>
                            </FormGroup>
                          </>
                        )}
                        <Button type="button" color="secondary" block onClick={prevStep}>
                          Voltar
                        </Button>
                      </Form>
                    )}
                  </Formik>
                )}
              </CardBody>
            </Card>
          </Col>
        </Row>
      </Container>
    </div>
  );
};

export default RecoverPassword;
