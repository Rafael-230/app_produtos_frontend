import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Produtos',
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
// TELA 1: LOGIN
// ==========================================
class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
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
              const TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              const Text('Senha'),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaProdutos(),
                    ),
                  );
                },
                child: const Text(
                  'ENTRAR',
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
// TELA 2: LISTA DE PRODUTOS
// ==========================================
List<Map<String, String>> listaProdutos = [
  {
    "nome": "Notebook",
    "desc": "Processador rápido",
    "cat": "Eletrônicos",
    "valor": "3500,00",
  },
  {
    "nome": "Cadeira de Escritório",
    "desc": "Ergonômica",
    "cat": "Móveis",
    "valor": "800,00",
  },
];

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PRODUTOS',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listaProdutos.length,
                itemBuilder: (context, index) {
                  final prod = listaProdutos[index];
                  return Card(
                    color: Colors.grey[200],
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[400],
                        child: const Icon(Icons.image, color: Colors.white),
                      ),
                      title: Text(
                        prod['nome']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${prod['desc']!}\n${prod['cat']!} • R\$ ${prod['valor']!}',
                      ),
                      isThreeLine: true,
                      // NOVIDADE: Botões de Editar e Excluir
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              // Abre a tela passando os dados do produto atual
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TelaCadastro(
                                    indexEdicao: index,
                                    produto: prod,
                                  ),
                                ),
                              );
                              setState(() {}); // Atualiza a tela ao voltar
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Remove o item da lista e atualiza a tela
                              setState(() {
                                listaProdutos.removeAt(index);
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
                      builder: (context) => const TelaCadastro(),
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
  final int? indexEdicao;
  final Map<String, String>? produto;

  // Recebe os parâmetros opcionais
  const TelaCadastro({super.key, this.indexEdicao, this.produto});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _nomeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();
  final _catCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Se recebeu um produto, preenche os campos automaticamente
    if (widget.produto != null) {
      _nomeCtrl.text = widget.produto!['nome'] ?? '';
      _descCtrl.text = widget.produto!['desc'] ?? '';
      _catCtrl.text = widget.produto!['cat'] ?? '';
      _valorCtrl.text = widget.produto!['valor'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Muda o título dependendo se é cadastro ou edição
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
            const SizedBox(height: 15),

            const Text('Imagem (URL - Opcional)'),
            const TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
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
                };

                if (isEdicao) {
                  // Se for edição, substitui o produto na posição correta
                  listaProdutos[widget.indexEdicao!] = novoProduto;
                } else {
                  // Se for novo, adiciona no final da lista
                  listaProdutos.add(novoProduto);
                }

                Navigator.pop(context); // Volta para a tela anterior
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
