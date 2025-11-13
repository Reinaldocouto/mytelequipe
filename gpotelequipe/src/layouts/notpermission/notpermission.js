 function Notpermission() {
  return (
    <div
      style={{
        color: '#c0392b',
        fontWeight: 'bold',
        padding: '15px 20px',
        border: '2px solid #c0392b',
        borderRadius: '8px',
        backgroundColor: '#fee0d2',
        boxShadow: '0px 2px 5px rgba(0, 0, 0, 0.15)',
        backgroundImage: `url("https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.sinalplast.com.br%2Fproduto%2Fplaca-atencao-nao-entre-sem-autorizacao-30x20-cm%2F&psig=AOvVaw299f7KtjyXiK4DkV8fwhNa&ust=1718728404565000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCLjDp7OI44YDFQAAAAAdAAAAABA2")`,
        backgroundSize: 'cover',
        backgroundRepeat: 'no-repeat',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      <span aria-label="No access permission">Sem permissão de acesso</span>
    </div>
  );
 }

export default Notpermission;
