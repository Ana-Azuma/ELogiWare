# Formativa ELogiWare - Escola e Faculdade de Tecnologia Senai Roberto Mange

Projeto E-LogiWare

Eficiência na Armazenagem Logística

 1. Introdução 
O projeto de Armazenagem Eficiente visa implementar um sistema de gestão de armazéns que otimize o uso do espaço, aprimore o controle de estoque, e a eficiência nas operações de picking, packing, expedição e recebimento. 

O banco de dados desempenhará um papel fundamental na organização, rastreamento e gerenciamento de informações relacionadas ao armazenamento de produtos.

 2. Objetivos 

- Otimizar o uso do espaço de armazenamento. - Melhorar a precisão e eficiência nas operações de picking e packing. - Agilizar os processos de expedição e recebimento. - Facilitar a gestão de estoque e a rastreabilidade de produtos. 

3. Estrutura do Banco de Dados 
3.1. Modelagem de Dados 
- Entidades Principais: 
 - Armazenamento 
 - Produto 
 - Pedido 
 - Transportadora
 - Fornecedor 
- Relacionamentos:
 - Associação entre produtos e seus locais de armazenamento. 
 - Vínculo entre pedidos, produtos e clientes. 
 - Registro de fornecedores associados a produtos específicos. 

3.2. Tabelas 
1. Tabela de Armazenamento: 
 - ID de armazenamento 
- Capacidade total
 - Capacidade utilizada 

2. Tabela de Produto: 
 - ID de produto 
 - Descrição 
 - Quantidade em estoque
 - Local de armazenamento (chave estrangeira) 

3. Tabela de Pedido:
 - ID de pedido 
 - Data do pedido 
 - Status do pedido 

4. Tabela de Transportadora: 
 - ID de transportadora 
 - Nome 
 - Contato 

5. Tabela de Fornecedor: 
 - ID de fornecedor
 - Nome 
 - Contato 

3.3. Diagrama de Entidade-Relacionamento (ERD) [Inserir Diagrama ERD aqui] 

4. Funcionalidades do Banco de Dados

4.1. Controle de Estoque 
- Atualização automática da quantidade em estoque com base nos pedidos. 
- Rastreamento do histórico de movimentação de produtos. 

4.2. Gestão de Armazenamento
 - Atribuição dinâmica de locais de armazenamento conforme a capacidade disponível. 
- Monitoramento do espaço utilizado em cada área de armazenamento. 

4.3. Controle de Pedidos 
- Registo detalhado de pedidos, incluindo produtos associados e status. 
- Vínculo com clientes e informações de entrega. 

4.4. Gestão de Transportadoras e Fornecedores 
- Registro de informações relevantes para facilitar a logística. 
- Associação de fornecedores a produtos específicos para otimizar a reposição. 

5. SQL e Procedimentos Armazenados 

5.1. SQL para Consultas 
- Consultas eficientes para verificar disponibilidade de produtos. 
- Extração de relatórios de movimentação e níveis de estoque. 

5.2. Procedimentos Armazenados 
- Procedimentos para automatizar tarefas recorrentes, como atualização de estoque. 
- Scripts para gerenciamento de armazenamento, incluindo alocação dinâmica. 

6. Segurança e Backup 

6.1. Controle de Acesso 
- Implementação de perfis de acesso para garantir segurança dos dados. 
- Restrições de acesso baseadas em funções e responsabilidades. 

6.2. Política de Backup 
 - Rotinas regulares de backup para garantir a integridade dos dados. 
- Armazenamento seguro dos backups em local externo. 

7. Conclusão
 O Projeto de Armazenagem Eficiente propõe uma solução abrangente para melhorar a eficiência e controle nas operações logísticas. A estrutura do banco de dados é projetada para ser flexível, segura e capaz de suportar o crescimento futuro da organização.
