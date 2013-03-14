__device__ void Compute(MessageIterator* msgs) {
  unsigned level = (get_id() == get_source() ? 0 : get_level());
  for (; !msgs->Done(); msgs->Next()) {
    level = msgs->get_level();
  }
  if (level < get_level()) {
    set_level(level);
    for (OutEdgeIterator it = GetOutEdgeIterator(); !it.Done(); it.Next()) {
      Message msg(*it);
      msg.set_level(level + 1);
      msg.Send();
    }
  }
}
