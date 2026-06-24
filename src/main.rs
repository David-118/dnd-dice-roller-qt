use qtbridge::{QApp, qobject};

#[qobject]
mod backend {
    use tyche::{Expr, dice::roller::FastRand};
    pub type Error = Box<dyn std::error::Error + Send + Sync>;

    #[derive(Default, Debug)]
    pub struct DiceBackend {
        roller: FastRand,
    }

    impl DiceBackend {
        #[qslot]
        fn process_expression(&mut self, expression: &str) {
            let err = self.calc_expression(expression);
            match err {
                Ok(_) => (),
                Err(err) => {
                    self.top_text_change(String::from("Error"));
                    self.bottom_text_change(err.to_string());
                }
            };
        }

        fn calc_expression(&mut self, expression: &str) -> Result<(), Error> {
            let expr: Expr = expression.parse()?;
            let evald = expr.eval(&mut self.roller)?;
            let result = evald.calc()?;

            self.top_text_change(result.to_string());
            self.bottom_text_change(evald.to_string());
            Ok(())
        }

        #[qsignal]
        fn top_text_change(&self, result: String);

        #[qsignal]
        fn bottom_text_change(&self, result: String);
    }
}

fn main() {
    <backend::DiceBackend as qtbridge::QmlRegister>::register();
    QApp::new().load_qml(include_bytes!("qml/Main.qml")).run();
}
