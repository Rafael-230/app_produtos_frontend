import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Products',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TelaLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========================================
// "BANCO DE DADOS" EM MEMÓRIA (Frontend Only)
// ==========================================
// Guarda Usuário -> Senha
Map<String, String> dbUsuarios = {
  "admin": "123", // Conta padrão já criada para facilitar os testes
};

// Guarda Usuário -> Lista de Produtos
Map<String, List<Map<String, dynamic>>> dbProdutos = {
  "admin": [
    {
      "nome": "Drone Mavic 3",
      "desc": "Para mapeamento aéreo",
      "cat": "Equipamentos",
      "valor": "25000,00",
      "imagemBytes": null,
    },
    {
      "nome": "Vector Optics",
      "desc": "Equipamento Tático",
      "cat": "Acessórios",
      "valor": "1200,00",
      "imagemBytes": null,
    },
  ],
};

// ==========================================
// TELA 1: LOGIN
// ==========================================
class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _usuarioCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();

  void _fazerLogin() {
    String user = _usuarioCtrl.text.trim();
    String pass = _senhaCtrl.text;

    // Verifica se o usuário existe e a senha bate
    if (dbUsuarios.containsKey(user) && dbUsuarios[user] == pass) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaProdutos(usuarioLogado: user),
        ),
      );
    } else {
      // Mostra mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário ou senha incorretos!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'LOGIN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              const Text('Usuário'),
              TextField(
                controller: _usuarioCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),

              const Text('Senha'),
              TextField(
                controller: _senhaCtrl,
                obscureText: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _fazerLogin,
                child: const Text(
                  'ENTRAR',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaRegistro(),
                    ),
                  );
                },
                child: const Text(
                  'Não tem uma conta? Cadastre-se',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TELA 1.5: REGISTRO DE USUÁRIO
// ==========================================
class TelaRegistro extends StatefulWidget {
  const TelaRegistro({super.key});

  @override
  State<TelaRegistro> createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
  final _usuarioCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();

  void _registrar() {
    String user = _usuarioCtrl.text.trim();
    String pass = _senhaCtrl.text;

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (dbUsuarios.containsKey(user)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário já existe! Escolha outro.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Salva o novo usuário e cria uma lista de produtos vazia só para ele
    setState(() {
      dbUsuarios[user] = pass;
      dbProdutos[user] = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conta criada com sucesso! Faça o login.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context); // Volta para a tela de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Conta', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Escolha um Usuário'),
            TextField(
              controller: _usuarioCtrl,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            const Text('Crie uma Senha'),
            TextField(
              controller: _senhaCtrl,
              obscureText: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _registrar,
              child: const Text(
                'CRIAR CONTA',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TELA 2: LISTA DE PRODUTOS
// ==========================================
class TelaProdutos extends StatefulWidget {
  final String usuarioLogado; // Recebe o nome de quem logou
  const TelaProdutos({super.key, required this.usuarioLogado});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  @override
  Widget build(BuildContext context) {
    // Puxa apenas a lista do usuário que está logado
    List<Map<String, dynamic>> minhaLista = dbProdutos[widget.usuarioLogado]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PRODUTOS (${widget.usuarioLogado})',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TelaLogin()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: minhaLista.isEmpty
                  ? const Center(
                      child: Text('Nenhum produto cadastrado ainda.'),
                    )
                  : ListView.builder(
                      itemCount: minhaLista.length,
                      itemBuilder: (context, index) {
                        final prod = minhaLista[index];
                        return Card(
                          color: Colors.grey[200],
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: prod['imagemBytes'] != null
                                  ? Image.memory(
                                      prod['imagemBytes'],
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                            ),
                            title: Text(
                              prod['nome']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${prod['desc']!}\n${prod['cat']!} • R\$ ${prod['valor']!}',
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TelaCadastro(
                                          usuarioLogado: widget.usuarioLogado,
                                          indexEdicao: index,
                                          produto: prod,
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      minhaLista.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[500],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Cadastrar novo produto',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TelaCadastro(usuarioLogado: widget.usuarioLogado),
                    ),
                  );
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TELA 3: CADASTRO E EDIÇÃO
// ==========================================
class TelaCadastro extends StatefulWidget {
  final String usuarioLogado; // Precisa saber de quem é o produto
  final int? indexEdicao;
  final Map<String, dynamic>? produto;

  const TelaCadastro({
    super.key,
    required this.usuarioLogado,
    this.indexEdicao,
    this.produto,
  });

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _nomeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();
  final _catCtrl = TextEditingController();

  Uint8List? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    if (widget.produto != null) {
      _nomeCtrl.text = widget.produto!['nome'] ?? '';
      _descCtrl.text = widget.produto!['desc'] ?? '';
      _catCtrl.text = widget.produto!['cat'] ?? '';
      _valorCtrl.text = widget.produto!['valor'] ?? '';
      _imagemSelecionada = widget.produto!['imagemBytes'];
    }
  }

  Future<void> _escolherImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imagemSelecionada = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdicao = widget.indexEdicao != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdicao ? 'EDITAR PRODUTO' : 'CADASTRAR PRODUTO',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _escolherImagem,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[500]!),
                ),
                child: _imagemSelecionada != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _imagemSelecionada!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.black54,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Toque para adicionar foto',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 25),
            const Text('Nome'),
            TextField(
              controller: _nomeCtrl,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            const Text('Descrição'),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            const Text('Valor'),
            TextField(
              controller: _valorCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            const Text('Categoria (Opcional)'),
            TextField(
              controller: _catCtrl,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                final novoProduto = {
                  "nome": _nomeCtrl.text.isEmpty ? "Sem Nome" : _nomeCtrl.text,
                  "desc": _descCtrl.text.isEmpty
                      ? "Sem Descrição"
                      : _descCtrl.text,
                  "cat": _catCtrl.text.isEmpty
                      ? "Sem Categoria"
                      : _catCtrl.text,
                  "valor": _valorCtrl.text.isEmpty ? "0,00" : _valorCtrl.text,
                  "imagemBytes": _imagemSelecionada,
                };

                // Pega a lista do usuário atual e atualiza
                List<Map<String, dynamic>> minhaLista =
                    dbProdutos[widget.usuarioLogado]!;

                if (isEdicao) {
                  minhaLista[widget.indexEdicao!] = novoProduto;
                } else {
                  minhaLista.add(novoProduto);
                }

                Navigator.pop(context);
              },
              child: const Text(
                'SALVAR',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
