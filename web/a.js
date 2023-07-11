import { Script } from 'node_modules/molstar/lib/mol-script/script';
import { StructureSelection } from 'node_modules/molstar/lib/mol-model/structure/query';

const data = plugin.managers.structure.hierarchy.current.structures[0]?.cell.obj?.data;
if (!data) throw new Error('Structure data not available');

const selection = Script.getStructureSelection(Q =>
  Q.struct.generator.atomGroups({
    'chain-test': Q.core.rel.eq(['B', Q.ammp('1H00')])
  }),
  data
);
const loci = StructureSelection.toLociWithSourceUnits(selection);

plugin.managers.interactivity.lociHighlights.highlightOnly({ loci });
plugin.log.message('This message will appear in the Mol* console');
