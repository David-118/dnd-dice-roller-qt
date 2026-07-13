use qtbridge::{QApp, QModelItem, qobject};
use std::collections::HashMap;

#[qobject]
mod dice_backend {
    use std::{cell::RefCell, rc::Rc};

    use qtbridge::QListModelBase;
    use tyche::{Expr, dice::roller::FastRand};

    use crate::{HistoryEntry, history_model::HistoryModel};
    pub type Error = Box<dyn std::error::Error + Send + Sync>;

    #[derive(Default)]
    pub struct DiceBackend {
        roller: FastRand,
        history: Rc<RefCell<HistoryModel>>,
    }

    impl DiceBackend {
        qproperty!("historyModel", Member = history);
        #[qslot(qml_name = "processExpression")]
        fn process_expression(&mut self, expression: String) {
            let err = self.calc_expression(expression);
            match err {
                Ok(_) => (),
                Err(err) => {
                    self.top_text_change(String::from("Error"));
                    self.bottom_text_change(err.to_string());
                }
            };
        }

        fn calc_expression(&mut self, expression: String) -> Result<(), Error> {
            let expr: Expr = expression.parse()?;
            let evald = expr.eval(&mut self.roller)?;
            let result = evald.calc()?;

            self.add_to_history(HistoryEntry {
                expression: expression,
                rolls: evald.to_string(),
                result: result.to_string(),
            });

            self.top_text_change(result.to_string());
            self.bottom_text_change(evald.to_string());
            Ok(())
        }

        fn add_to_history(&mut self, entry: HistoryEntry) {
            self.history.borrow_mut().insert(0, entry);
        }

        #[qsignal(qml_name = "topTextChange")]
        fn top_text_change(&mut self, result: String);

        #[qsignal(qml_name = "bottomTextChange")]
        fn bottom_text_change(&mut self, result: String);
    }
}

#[derive(Default, Clone, QModelItem, Debug)]
pub struct HistoryEntry {
    expression: String,
    rolls: String,
    result: String,
}

#[qobject(Base = QListModel)]
mod history_model {
    use crate::HistoryEntry;
    use qtbridge::QListModel;

    #[derive(Default)]
    pub struct HistoryModel {
        entries: Vec<HistoryEntry>,
    }

    impl QListModel for HistoryModel {
        type Item = HistoryEntry;

        fn len(&self) -> usize {
            self.entries.len()
        }

        fn get(&self, index: usize) -> Option<&Self::Item> {
            self.entries.get(index)
        }

        fn set_unnotified(&mut self, index: usize, value: Self::Item) -> bool {
            self.entries[index] = value;
            true
        }

        fn push_unnotified(&mut self, value: Self::Item) {
            self.entries.push(value);
        }

        fn insert_unnotified(&mut self, index: usize, value: Self::Item) {
            self.entries.insert(index, value);
        }

        fn remove_unnotified(&mut self, index: usize) -> Self::Item {
            self.entries.remove(index)
        }
    }
}

fn main() {
    QApp::new()
        .register::<history_model::HistoryModel>()
        .register::<dice_backend::DiceBackend>()
        .load_qml(include_bytes!("qml/Main.qml"))
        .run();
}
