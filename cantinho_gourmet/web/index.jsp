<%-- 
    Document   : index
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>



<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cantinho Gourmet - Sistema de Gestão</title>

    <style>
        /* Zerando margens e deixando tudo no padrão */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        /* Fundo com gradiente e centralizando a tela */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        /* Área principal branca */
        .container {
            max-width: 1000px;
            width: 100%;
            background: white;
            border-radius: 20px;
            padding: 50px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
        }
        
        /* Emoji da logo com animação */
        .logo {
            font-size: 4em;
            margin-bottom: 10px;
            animation: bounce 2s infinite;
        }
        
        /* Efeito de pulo */
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        /* Título */
        h1 {
            color: #764ba2;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        /* Subtítulo */
        .subtitle {
            color: #666;
            font-size: 1.2em;
            margin-bottom: 50px;
        }
        
        /* Grid dos botões */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            margin-top: 40px;
        }
        
        /* Cartões do menu */
        .menu-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 35px 25px;
            border-radius: 15px;
            text-decoration: none;
            color: white;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            position: relative;
            overflow: hidden;
        }
        
        /* Efeito de brilho passando */
        .menu-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.1);
            transition: left 0.5s;
        }
        
        /* Faz o brilho andar */
        .menu-card:hover::before {
            left: 100%;
        }
        
        /* Efeito de levantar no hover */
        .menu-card:hover {
            transform: translateY(-10px) scale(1.05);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
        }
        
        /* Cores específicas por módulo */
        .menu-card.fornecedor { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .menu-card.produto { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .menu-card.funcionario { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
        .menu-card.pedido { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        
        /* Ícone do cartão */
        .menu-icon {
            font-size: 3em;
            margin-bottom: 15px;
            display: block;
        }
        
        /* Título do cartão */
        .menu-title {
            font-size: 1.4em;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        /* Mini descrição */
        .menu-description {
            font-size: 0.9em;
            opacity: 0.95;
            line-height: 1.4;
        }
        
        /* Rodapé */
        .footer {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 2px solid #eee;
            color: #999;
            font-size: 0.9em;
        }
    </style>
</head>
<body>

    <!-- Container principal -->
    <div class="container">

        <!-- Logo animada -->
        <div class="logo">🎂</div>

        <!-- Nome do sistema -->
        <h1>Cantinho Gourmet</h1>

        <!-- Subtítulo explicando -->
        <p class="subtitle">Sistema Integrado de Gestão de Confeitaria</p>
        
        <!-- Grid com os menus -->
        <div class="menu-grid">

            <!-- Clientes -->
            <a href="clientes/listarClientes.jsp" class="menu-card">
                <span class="menu-icon">👥</span>
                <div class="menu-title">Clientes</div>
                <div class="menu-description">Gerencie seus clientes e histórico de pedidos</div>
            </a>
            
            <!-- Fornecedores -->
            <a href="fornecedores/listarFornecedores.jsp" class="menu-card fornecedor">
                <span class="menu-icon">🏭</span>
                <div class="menu-title">Fornecedores</div>
                <div class="menu-description">Controle fornecedores de ingredientes</div>
            </a>
            
            <!-- Produtos -->
            <a href="produtos/listarProdutos.jsp" class="menu-card produto">
                <span class="menu-icon">🍰</span>
                <div class="menu-title">Produtos</div>
                <div class="menu-description">Catálogo de doces e produtos</div>
            </a>
            
            <!-- Funcionários -->
            <a href="funcionarios/listarFuncionarios.jsp" class="menu-card funcionario">
                <span class="menu-icon">👨‍🍳</span>
                <div class="menu-title">Funcionários</div>
                <div class="menu-description">Gestão de equipe e folha de pagamento</div>
            </a>
            
            <!-- Pedidos -->
            <a href="pedidos/listarPedidos.jsp" class="menu-card pedido">
                <span class="menu-icon">🛒</span>
                <div class="menu-title">Pedidos</div>
                <div class="menu-description">Sistema transacional de pedidos</div>
            </a>
        </div>
        
        <!-- Rodapé -->
        <div class="footer">
            <p>© 2025 Cantinho Gourmet - Todos os Direitos Reservados</p>
        </div>

    </div>
</body>
</html>
